import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:retrofit/dio.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/drawer_state.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerCubit extends Cubit<DrawerState> {
  final AuthRepository _authRepository;
  final CachingManager _cacheManager;

  late final List<Brand> authorizedBrands;
  late final List<Brand> unauthorizedBrands;
  late final UserStatus? userStatus;

  Timer? _copyTimer;

  final Uri _url = Uri.parse(AppConstants.webToolUrl);

  DrawerCubit(
    this._authRepository,
    this._cacheManager,
  ) : super(const DrawerState()) {
    getVersion();
    authorizedBrands = _cacheManager.getAuthorizedBrands().reversed.toList();
    unauthorizedBrands = _cacheManager.getUnauthorizedBrands();
    userStatus = _cacheManager.getUserStatus();
  }

  @override
  Future<void> close() async {
    _copyTimer?.cancel();
    return super.close();
  }

  void changeCurrentBrand(Brand newBrand) {
    _cacheManager.saveCurrentBrand(newBrand);
    Get.back();
  }

  Future<void> logout(Brand brand) async {
    final HttpResponse response = await _authRepository.logout();
    if (response.response.statusCode == 200) {
      final bool isOk = await _cacheManager.logout(brand);
      if (isOk) {
        final List<Brand> authorizedBrands =
            _cacheManager.getAuthorizedBrands();
        if (authorizedBrands.isNotEmpty) {
          Get.back();
          changeCurrentBrand(authorizedBrands.first);
        } else {
          Get.offNamedUntil(AppRoutes.login, (route) => false);
        }
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
    Get.back();
    Get.toNamed(AppRoutes.allBrands);
  }

  void goToCustomerSupport() {
    Get.back();
    Get.toNamed(AppRoutes.support);
  }

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String build = packageInfo.buildNumber;
    emit(state.copyWith(version: '$version ($build)'));
  }

  void tapToCopy() async {
    await Clipboard.setData(ClipboardData(text: state.version));
    if (_copyTimer == null || _copyTimer?.isActive == false) {
      emit(state.copyWith(copyButtonTapped: true));
      _copyTimer = Timer(const Duration(seconds: 2), () {
        emit(state.copyWith(copyButtonTapped: false));
      });
    }
    ClipboardData? data = await Clipboard.getData('text/plain');
    logger.d(data?.text);
  }
}
