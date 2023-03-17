import 'dart:async';
import 'dart:io';

import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/main_state.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:shared_advisor_interface/services/fresh_chat_service.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/infrastructure/di/modules/api_module.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@singleton
class MainCubit extends Cubit<MainState> {
  final GlobalCachingManager _cacheManager;
  final AppRouter _routerService;

  late final StreamSubscription _currentBrandSubscription;
  late final StreamSubscription _localeSubscription;
  late final StreamSubscription<bool> _connectivitySubscription;

  final PublishSubject<bool> changeAppLifecycleStream = PublishSubject();
  final PublishSubject<bool> audioStopTrigger = PublishSubject();

  final ConnectivityService _connectivityService;

  MainCubit(
    this._routerService,
    this._cacheManager,
    this._connectivityService,
  ) : super(const MainState()) {
    _connectivitySubscription =
        _connectivityService.connectivityStream.listen((event) {
      emit(state.copyWith(internetConnectionIsAvailable: event));
    });

    emit(state.copyWith(
        currentBrand: _cacheManager.getCurrentBrand() ?? Brand.fortunica));

    _currentBrandSubscription = _cacheManager.listenCurrentBrandStream((value) {
      // logger.d('CHANGE');
      // _routerService.navigateToRouteName(
      //     path: '/${value.alias}');
      emit(state.copyWith(currentBrand: value));
    });

    _localeSubscription = _cacheManager.listenLanguageCodeStream(changeLocale);
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    _connectivityService.disposeStream();
    _localeSubscription.cancel();
    _currentBrandSubscription.cancel();
    return super.close();
  }

  void changeCurrentBrand(Brand brand) {
    _cacheManager.saveCurrentBrand(brand);
  }

  void updateIsLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  void widgetOnResumeEvent() {
    changeAppLifecycleStream.add(true);
  }

  void widgetOnPauseEvent() {
    changeAppLifecycleStream.add(false);
  }

  void stopAudio() {
    audioStopTrigger.add(true);
  }

  void changeLocale(String languageCode) {
    if (Platform.isAndroid) {
      globalGetIt.get<FreshChatService>().changeLocaleInvite();
    }

    fortunicaGetIt.get<Dio>().addLocaleToHeader(languageCode);

    emit(state.copyWith(
        locale: Locale(languageCode, languageCode.toUpperCase())));
  }
}
