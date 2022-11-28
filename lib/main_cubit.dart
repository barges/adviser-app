import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_state.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/fresh_chat_service.dart';

class MainCubit extends Cubit<MainState> {
  final CachingManager cacheManager;

  late final VoidCallback disposeCallback;
  late final StreamSubscription<bool> _connectivitySubscription;

  final PublishSubject<bool> sessionsUpdateTrigger = PublishSubject();

  final ConnectivityService _connectivityService;

  MainCubit(this.cacheManager, this._connectivityService)
      : super(const MainState()) {
    _connectivitySubscription =
        _connectivityService.connectivityStream.listen((event) {
      emit(state.copyWith(internetConnectionIsAvailable: event));
    });

    emit(state.copyWith(
        currentBrand: cacheManager.getCurrentBrand() ?? Brand.fortunica));
    disposeCallback = cacheManager.listenCurrentBrand((value) {
      emit(state.copyWith(currentBrand: value));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    _connectivityService.disposeStream();
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

  void updateSessions() {
    sessionsUpdateTrigger.add(true);
  }

  void changeLocale(int index) {
    final Locale locale = S.delegate.supportedLocales[index];

    if (Platform.isAndroid) {
      getIt.get<FreshChatService>().changeLocaleInvite();
    }
    getIt.get<CachingManager>().saveLocaleIndex(index);

    emit(state.copyWith(
        locale:
            Locale(locale.languageCode, locale.languageCode.toUpperCase())));
  }
}
