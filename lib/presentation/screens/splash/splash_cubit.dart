import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/splash/splash_state.dart';
import 'package:shared_advisor_interface/presentation/services/check_permission_service.dart';
import 'package:shared_advisor_interface/presentation/services/fresh_chat_service.dart';

class SplashCubit extends Cubit<SplashState> {
  final CachingManager _cacheManager;
  final CheckPermissionService _checkPermissionService;
  final bool _isDarkMode;

  SplashCubit(this._cacheManager, this._checkPermissionService,
      this._isDarkMode, BuildContext context)
      : super(const SplashState()) {
    _checkLoggedStatus(context);
  }

  Future<void> _checkLoggedStatus(BuildContext context) async {
    getIt.get<FreshChatService>().initFreshChat(_isDarkMode);
    await AppTrackingTransparency.requestTrackingAuthorization();
    // ignore: use_build_context_synchronously
    await _checkPermissionService.handlePermission(
        context, PermissionType.notification,
        needShowSettings: false);
    Future.delayed(const Duration(seconds: 2)).then(
        (value) => emit(state.copyWith(isLogged: _cacheManager.isLoggedIn())));
  }
}
