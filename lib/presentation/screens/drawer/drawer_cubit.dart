import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/splash/splash_state.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerCubit extends Cubit<SplashState> {
  final CachingManager _cacheManager;

  late final List<Brand> authorizedBrands;
  late final List<Brand> unauthorizedBrands;
  late final UserStatus? userStatus;

  final Uri _url = Uri.parse(AppConstants.webToolUrl);

  DrawerCubit(this._cacheManager) : super(const SplashState()) {
    authorizedBrands = _cacheManager.getAuthorizedBrands().reversed.toList();
    unauthorizedBrands = _cacheManager.getUnauthorizedBrands();
    userStatus = _cacheManager.getUserStatus();
  }

  void changeCurrentBrand(Brand newBrand) {
    _cacheManager.saveCurrentBrand(newBrand);
    Get.back();
  }

  Future<void> logout(Brand brand) async {
    final bool isOk = await _cacheManager.logout(brand);
    if (isOk) {
      final List<Brand> authorizedBrands = _cacheManager.getAuthorizedBrands();
      if (authorizedBrands.isNotEmpty) {
        Get.back();
        changeCurrentBrand(authorizedBrands.first);
      } else {
        Get.offNamedUntil(AppRoutes.login, (route) => false);
      }
    }
  }

  Future<void> openSettingsUrl() async {
    if (!await launchUrl(
      _url,
      mode: LaunchMode.externalApplication,
    )) {
      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        message: 'Could not launch $_url',
      ));
    }
  }

  void goToAllBrands() {
    Get.toNamed(AppRoutes.allBrands);
  }

  void goToCustomerSupport() {
    Get.toNamed(AppRoutes.support);
  }
}
