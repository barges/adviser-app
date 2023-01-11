import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';

const String resetLinkKey = '/reset';
const String brandQueryKey = 'brand';
const String tokenQueryKey = 'token';

class DynamicLinkService {
  String? _initialLink;

  final PublishSubject<DynamicLinkData> dynamicLinksStream = PublishSubject();

  DynamicLinkService() {
    FirebaseDynamicLinks.instance.onLink.listen(
      (PendingDynamicLinkData dynamicLink) async {
        final String link = dynamicLink.link.toString();
        dynamicLinksStream.add(parseDynamicLink(link));
        logger.d(link);
        if (Get.currentRoute == AppRoutes.login) {
          checkLinkForResetPassword(link: link);
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

  Future<void> checkLinkForResetPassword({String? link}) async {
    final String? initLink = link ?? await retrieveDynamicInitialLink();
    if (initLink != null && initLink.contains(resetLinkKey)) {
      final DynamicLinkData dynamicLinkData = parseDynamicLink(initLink);
      Get.toNamed(
        AppRoutes.forgotPassword,
        arguments: ForgotPasswordScreenArguments(
          brand: dynamicLinkData.brand,
          resetToken: dynamicLinkData.token,
        ),
      );
    }
  }

  DynamicLinkData parseDynamicLink(String link) {
    final String queriesString = link.split('?').lastOrNull ?? '';
    final Map<String, String> queriesMap = Uri.splitQueryString(queriesString);
    return DynamicLinkData(
        brand: Brand.brandFromName(queriesMap[brandQueryKey]),
        token: queriesMap[tokenQueryKey]);
  }
}

class DynamicLinkData {
  final Brand brand;
  final String? token;

  DynamicLinkData({
    required this.brand,
    this.token,
  });
}
