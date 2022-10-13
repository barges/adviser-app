import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/main_state.dart';

class MainCubit extends Cubit<MainState> {
  final CacheManager cacheManager;

  late final VoidCallback disposeCallback;

  MainCubit(this.cacheManager) : super(const MainState()) {
    emit(state.copyWith(
        currentBrand: cacheManager.getCurrentBrand() ?? Brand.fortunica));
    disposeCallback = cacheManager.listenCurrentBrand((value) {
      emit(state.copyWith(currentBrand: value));
    });
  }

  @override
  Future<void> close() {
    disposeCallback.call();
    return super.close();
  }

  void updateIsLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  List<Brand> getAuthorizedBrands() {
    return cacheManager.getAuthorizedBrands();
  }

  void updateErrorMessage(String message) {
    emit(state.copyWith(errorMessage: message));
  }

  void clearErrorMessage() {
    if (state.errorMessage.isNotEmpty) {
      emit(state.copyWith(errorMessage: ''));
    }
  }

  void clearSuccessMessage() {
    if (state.successMessage.isNotEmpty) {
      emit(
        state.copyWith(
          successMessage: '',
        ),
      );
    }
  }

  void updateSuccessMessage(String message) {
    emit(state.copyWith(successMessage: message));
  }
}
