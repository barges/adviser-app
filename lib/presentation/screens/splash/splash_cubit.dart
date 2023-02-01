import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/splash/splash_state.dart';
import 'package:shared_advisor_interface/presentation/services/fresh_chat_service.dart';

class SplashCubit extends Cubit<SplashState> {
  final CachingManager _cacheManager;
  final bool _isDarkMode;

  SplashCubit(this._cacheManager, this._isDarkMode)
      : super(const SplashState()) {
    _checkLoggedStatus();
  }

  Future<void> _checkLoggedStatus() async {
    getIt.get<FreshChatService>().initFreshChat(_isDarkMode);
    await AppTrackingTransparency.requestTrackingAuthorization();
    Future.delayed(const Duration(seconds: 2)).then(
        (value) => emit(state.copyWith(isLogged: _cacheManager.isLoggedIn())));
  }
}
