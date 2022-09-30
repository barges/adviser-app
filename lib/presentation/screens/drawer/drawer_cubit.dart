import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/splash/splash_state.dart';

class DrawerCubit extends Cubit<SplashState> {
  final CacheManager _cacheManager;

  late final List<Brand> authorizedBrands;
  late final List<Brand> unauthorizedBrands;

  DrawerCubit(this._cacheManager) : super(const SplashState()) {
    authorizedBrands = _cacheManager.getAuthorizedBrands().reversed.toList();
    unauthorizedBrands = _cacheManager.getUnauthorizedBrands();
  }

  void changeCurrentBrand(Brand newBrand) {
    _cacheManager.saveCurrentBrand(newBrand);
    Get.back();
  }

  Future<void> logout(Brand brand) async {
    final bool isOk = await _cacheManager.clearTokenForBrand(brand);
    if (isOk) {
      final List<Brand> authorizedBrands = _cacheManager.getAuthorizedBrands();
      logger.d(authorizedBrands.length);
      if (authorizedBrands.isNotEmpty) {
        Get.back();
        changeCurrentBrand(authorizedBrands.first);
      } else {
        Get.offNamedUntil(AppRoutes.login, (route) => false);
      }
    }
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
