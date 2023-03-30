import 'package:collection/collection.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:fortunica/fortunica.dart';
import 'package:fortunica/infrastructure/routing/route_paths_fortunica.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';

const String resetLinkKey = '/reset';
const String brandQueryKey = 'brand';
const String tokenQueryKey = 'token';

@singleton
class DynamicLinkService {
  String? _initialLink;

  final PublishSubject<DynamicLinkData> dynamicLinksStream = PublishSubject();

  DynamicLinkService() {
    FirebaseDynamicLinks.instance.onLink.listen(
      (PendingDynamicLinkData dynamicLink) async {
        final BuildContext? fortunicaContext = FortunicaBrand().context;

        final String link = dynamicLink.link.toString();
        dynamicLinksStream.add(parseDynamicLink(link));
        logger.d(link);
        if (fortunicaContext != null &&
            (fortunicaContext.currentRoutePath ==
                    RoutePathsFortunica.loginScreen ||
                fortunicaContext.currentRoutePath ==
                    RoutePathsFortunica.authScreen)) {
          checkLinkForResetPasswordFortunica(fortunicaContext, link: link);
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

  Future<void> checkLinkForResetPasswordFortunica(BuildContext context,
      {String? link}) async {
    final String? initLink = link ?? await retrieveDynamicInitialLink();

    if (initLink != null && initLink.contains(resetLinkKey)) {
      final DynamicLinkData dynamicLinkData = parseDynamicLink(initLink);

      context.push(
        route: FortunicaForgotPassword(
          resetToken: dynamicLinkData.token,
        ),
      );
    }
  }

  DynamicLinkData parseDynamicLink(String link) {
    final String queriesString = link.split('?').lastOrNull ?? '';
    final Map<String, String> queriesMap = Uri.splitQueryString(queriesString);
    return DynamicLinkData(
        brand: BrandManager.brandFromAlias(queriesMap[brandQueryKey]),
        token: queriesMap[tokenQueryKey]);
  }
}

class DynamicLinkData {
  final BaseBrand brand;
  final String? token;

  DynamicLinkData({
    required this.brand,
    this.token,
  });
}