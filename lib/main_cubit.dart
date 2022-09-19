import 'package:bloc/bloc.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/main_state.dart';

class MainCubit extends Cubit<MainState> {
  final CacheManager cacheManager;

  MainCubit(this.cacheManager) : super(const MainState()) {
    emit(state.copyWith(
        currentBrand: cacheManager.getCurrentBrand() ?? Brand.fortunica));
    cacheManager.listenCurrentBrand((value) {
      emit(state.copyWith(currentBrand: value));
    });
  }
}
