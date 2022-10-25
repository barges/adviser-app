import 'package:bloc/bloc.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/presentation/screens/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final CachingManager _cacheManager;

  SplashCubit(this._cacheManager) : super(const SplashState()) {
    _checkLoggedStatus();
  }

  Future<void> _checkLoggedStatus() async {
    Future.delayed(const Duration(seconds: 2)).then(
        (value) => emit(state.copyWith(isLogged: _cacheManager.isLoggedIn())));
  }
}
