import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/main_state.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:shared_advisor_interface/services/fresh_chat_service.dart';

@singleton
class MainCubit extends Cubit<MainState> {
  final GlobalCachingManager _cacheManager;

  late final StreamSubscription _currentBrandSubscription;
  late final StreamSubscription _localeSubscription;
  late final StreamSubscription<bool> _connectivitySubscription;

  final PublishSubject<bool> changeAppLifecycleStream = PublishSubject();
  final PublishSubject<bool> audioStopTrigger = PublishSubject();

  final ConnectivityService _connectivityService;

  MainCubit(
    this._cacheManager,
    this._connectivityService,
  ) : super(const MainState()) {
    _connectivitySubscription =
        _connectivityService.connectivityStream.listen((event) {
      emit(state.copyWith(internetConnectionIsAvailable: event));
    });

    final BaseBrand currentBrand = _cacheManager.getCurrentBrand();

    BrandManager.setIsCurrentForBrands(currentBrand);

    emit(state.copyWith(currentBrand: currentBrand));

    _currentBrandSubscription = _cacheManager.listenCurrentBrandStream((value) {
      emit(state.copyWith(
        currentBrand: value,
      ));
      BrandManager.setIsCurrentForBrands(value);

      final String? languageCode = value.languageCode;

      if (languageCode != null) {
        _cacheManager.saveLanguageCode(languageCode);
      }
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

  void changeCurrentBrand(BaseBrand brand) {
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

    logger.d(languageCode);

    emit(state.copyWith(
        locale: Locale(languageCode, languageCode.toUpperCase())));
  }
}
