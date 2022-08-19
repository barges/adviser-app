import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';

class SplashController extends GetxController {
  final CacheManager _cacheManager = Get.find<CacheManager>();

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (_cacheManager.isLoggedIn() == true) {
        Get.offNamed(AppRoutes.login);
      } else {
        Get.offNamed(AppRoutes.login);
      }
    });
  }
}
