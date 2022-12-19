import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/splash/splash_state.dart';
import 'package:shared_advisor_interface/presentation/services/fresh_chat_service.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

class SplashCubit extends Cubit<SplashState> {
  final CachingManager _cacheManager;
  final BuildContext _context;
  SplashCubit(this._cacheManager, this._context) : super(const SplashState()) {
    _checkLoggedStatus();
  }

  Future<void> _checkLoggedStatus() async {
    getIt.get<FreshChatService>().initFreshChat(Utils.isDarkMode(_context));
    await AppTrackingTransparency.requestTrackingAuthorization();
    Future.delayed(const Duration(seconds: 2)).then(
        (value) => emit(state.copyWith(isLogged: _cacheManager.isLoggedIn())));
  }
}
