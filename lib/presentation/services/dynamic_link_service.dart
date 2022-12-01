import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
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

  DynamicLinkService() {
    FirebaseDynamicLinks.instance.onLink.listen(
      (PendingDynamicLinkData dynamicLink) async {
        final String link = dynamicLink.link.toString();
        logger.d(link);
        if (Get.currentRoute == AppRoutes.login) {
          checkLinkForResetPassword(link: link);
        } else if (Get.currentRoute == AppRoutes.forgotPassword) {
          checkLinkForResetPassword(
            link: link,
            needReplace: true,
          );
        }
      },
      onError: (e) async {
        logger.d('DynamicLinkService.init(): ${e.toString()}');
      },
    );
  }

  Future<String?> retrieveDynamicInitialLink() async {
    if (_initialLink == null) {
      PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      if (data != null) {
        _initialLink = data.link.toString();
      }
    }
    return _initialLink;
  }

  Future<void> checkLinkForResetPassword(
      {String? link, bool needReplace = false}) async {
    final String? initLink = link ?? await retrieveDynamicInitialLink();
    if (initLink != null && initLink.contains(resetLinkKey)) {
      final String? queriesString = initLink.split('?').lastOrNull;
      if (queriesString != null) {
        final Map<String, String> queriesMap =
            Uri.splitQueryString(queriesString);
        if (needReplace) {
          Get.offNamed(
            AppRoutes.forgotPassword,
            arguments: ForgotPasswordScreenArguments(
              brand: Brand.brandFromName(queriesMap[brandQueryKey]),
              resetToken: queriesMap[tokenQueryKey],
            ),
            preventDuplicates: false,
          );
        } else {
          Get.toNamed(
            AppRoutes.forgotPassword,
            arguments: ForgotPasswordScreenArguments(
              brand: Brand.brandFromName(queriesMap[brandQueryKey]),
              resetToken: queriesMap[tokenQueryKey],
            ),
          );
        }
      }
    }
  }
}
