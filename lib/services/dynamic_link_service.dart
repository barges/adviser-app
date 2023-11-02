import 'package:collection/collection.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../global.dart';
import '../infrastructure/routing/app_router.gr.dart';
import '../infrastructure/routing/route_paths_fortunica.dart';

const String resetLinkKey = '/reset';
const String brandQueryKey = 'brand';
const String tokenQueryKey = 'token';

@singleton
class DynamicLinkService {
  String? _initialLink;

  final PublishSubject<DynamicLinkData> dynamicLinksStream = PublishSubject();
  final MainAppRouter rootRouter = globalGetIt.get<MainAppRouter>();

  DynamicLinkService() {
    FirebaseDynamicLinks.instance.onLink.listen(
      (PendingDynamicLinkData dynamicLink) async {
        final String link = dynamicLink.link.toString();
        dynamicLinksStream.add(parseDynamicLink(link));
        logger.d(link);
        if ((rootRouter.currentPath == RoutePathsFortunica.loginScreen ||
            rootRouter.currentPath == RoutePathsFortunica.authScreen)) {
          checkLinkForResetPasswordFortunica(link: link);
        }
      },
      onError: (e) async {
        logger.d('DynamicLinkService.init(): ${e.toString()}');
      },
    );
  }

  String? get initialLink => _initialLink;

  Future<String?> retrieveDynamicInitialLink() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) {
      _initialLink = data.link.toString();
    }
    return data?.link.toString();
  }

  Future<void> checkLinkForResetPasswordFortunica({String? link}) async {
    final String? initLink = link ?? await retrieveDynamicInitialLink();

    if (initLink != null && initLink.contains(resetLinkKey)) {
      final DynamicLinkData dynamicLinkData = parseDynamicLink(initLink);

      // ignore: use_build_context_synchronously
      rootRouter.push(
        FortunicaForgotPassword(
          resetToken: dynamicLinkData.token,
        ),
      );
    }
  }

  DynamicLinkData parseDynamicLink(String link) {
    final String queriesString = link.split('?').lastOrNull ?? '';
    final Map<String, String> queriesMap = Uri.splitQueryString(queriesString);
    return DynamicLinkData(
        //brand: BrandManager.brandFromAlias(queriesMap[brandQueryKey]),
        token: queriesMap[tokenQueryKey]);
  }
}

class DynamicLinkData {
  //final BaseBrand brand;
  final String? token;

  DynamicLinkData({
    //required this.brand,
    this.token,
  });
}
