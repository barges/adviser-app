import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:shared_advisor_interface/main.dart';

class DynamicLinkService {
  DynamicLinkService() {
    FirebaseDynamicLinks.instance.onLink.listen(
      (PendingDynamicLinkData dynamicLink) async {
        final String link = dynamicLink.link.toString();
        if (link.contains('secret=')) {
          final String secret = link.split('=').last;
          try {
            //Get.find<RestorePasswordController>().secret.value = secret;
          } catch (e) {
            logger.d('DynamicLinkService  --  onInit()');
            logger.d(e.toString());
          }
        }
      },
      onError: (e) async {
        logger.d('DynamicLinkService.init(): ${e.toString()}');
      },
    );
  }

  Future<String?> retrieveDynamicInitialLink() async {
    String? secret;
    PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) {
      final String deepLink = data.link.toString();
      if (deepLink.isNotEmpty) {
        if (deepLink.contains('secret=')) {
          secret = deepLink.split('=').last;
        }
      }
    }
    return secret;
  }
}
