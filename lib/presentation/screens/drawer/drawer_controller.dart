import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/presentation/base_screen/runnable_controller.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';

class AppDrawerController extends RunnableController {
  AppDrawerController(super.cacheManager);

  List<Brand> authorizedBrands() {
    return cacheManager.getAuthorizedBrands();
  }

  List<Brand> unauthorizedBrands() {
    return cacheManager.getUnauthorizedBrands();
  }

  void changeCurrentBrand(Brand newBrand) {
    cacheManager.saveCurrentBrand(newBrand);
    Get.back();
  }

  Future<void> logout(Brand brand) async {
    final bool isOk = await cacheManager.clearTokenForBrand(brand);
    if (isOk) {
      final List<Brand> authorizedBrands = cacheManager.getAuthorizedBrands();
      if (authorizedBrands.isNotEmpty) {
        changeCurrentBrand(authorizedBrands.first);
      } else {
        Get.offNamedUntil(AppRoutes.login, (route) => false);
      }
    }
    // Get.toNamed(AppRoutes.allBrands);
  }

  void goToAllBrands() {
    Get.toNamed(AppRoutes.allBrands);
  }

  void goToSettings() {
    Get.toNamed(AppRoutes.allBrands);
  }

  void goToCustomerSupport() {
    Get.toNamed(AppRoutes.allBrands);
  }
}
