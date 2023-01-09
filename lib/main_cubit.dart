import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/data/models/app_errors/empty_error.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_state.dart';
import 'package:shared_advisor_interface/presentation/di/modules/api_module.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/fresh_chat_service.dart';

class MainCubit extends Cubit<MainState> {
  final CachingManager cacheManager;

  late final VoidCallback _disposeCallback;
  late final VoidCallback _localeListenerDisposeCallback;
  late final StreamSubscription<bool> _connectivitySubscription;

  Timer? _errorTimer;

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

    _disposeCallback = cacheManager.listenCurrentBrand((value) {
      emit(state.copyWith(currentBrand: value));
    });

    _localeListenerDisposeCallback =
        cacheManager.listenLanguageCode(changeLocale);
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    _connectivityService.disposeStream();
    _localeListenerDisposeCallback.call();
    _disposeCallback.call();
    _errorTimer?.cancel();
    return super.close();
  }

  void updateIsLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  List<Brand> getAuthorizedBrands() {
    return cacheManager.getAuthorizedBrands();
  }

  void updateErrorMessage(AppError appError) {
    if (appError is! EmptyError) {
      emit(state.copyWith(appError: appError));
      _errorTimer = Timer(const Duration(seconds: 10), clearErrorMessage);
    }
  }

  void clearErrorMessage() {
    if (state.appError is! EmptyError) {
      emit(state.copyWith(appError: const EmptyError()));
    }
  }

  void updateSessions() {
    sessionsUpdateTrigger.add(true);
  }

  void changeLocale(String languageCode) {
    if (Platform.isAndroid) {
      getIt.get<FreshChatService>().changeLocaleInvite();
    }

    getIt.get<Dio>().addLocaleToHeader(languageCode);

    emit(state.copyWith(
        locale: Locale(languageCode, languageCode.toUpperCase())));
  }
}
