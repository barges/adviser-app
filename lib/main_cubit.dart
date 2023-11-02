import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../infrastructure/routing/app_router.dart';

import 'data/cache/caching_manager.dart';
import 'data/models/app_error/app_error.dart';
import 'global.dart';
import 'infrastructure/routing/app_router.gr.dart';
import 'main_state.dart';
import 'services/connectivity_service.dart';
import 'services/fresh_chat_service.dart';

@singleton
class MainCubit extends Cubit<MainState> {
  final CachingManager _cacheManager;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late final StreamSubscription _localeSubscription;
  late final StreamSubscription<bool> _connectivitySubscription;

  final PublishSubject<bool> changeAppLifecycleStream = PublishSubject();
  final PublishSubject<bool> audioStopTrigger = PublishSubject();
  final PublishSubject<bool> sessionsUpdateTrigger = PublishSubject();
  final PublishSubject<bool> updateAccountTrigger = PublishSubject();

  final ConnectivityService _connectivityService;

  Timer? _errorTimer;

  MainCubit(
    this._cacheManager,
    this._connectivityService,
  ) : super(const MainState()) {
    _connectivitySubscription =
        _connectivityService.connectivityStream.listen((event) {
      emit(state.copyWith(
        internetConnectionIsAvailable: event,
        isAuth: _cacheManager.isAuth,
      ));
    });

    _localeSubscription = _cacheManager.listenLanguageCodeStream(changeLocale);
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    _connectivityService.disposeStream();
    _localeSubscription.cancel();
    _errorTimer?.cancel();
    return super.close();
  }

  void updateErrorMessage(AppError appError) {
    if (appError is! EmptyError) {
      emit(state.copyWith(appError: appError));
      _errorTimer?.cancel();
      _errorTimer = Timer(const Duration(seconds: 10), clearErrorMessage);
    }
  }

  void clearErrorMessage() {
    if (state.appError is! EmptyError) {
      emit(state.copyWith(appError: const EmptyError()));
    }
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

    emit(state.copyWith(
        locale: Locale(languageCode, languageCode.toUpperCase())));
  }

  void updateSessions() {
    sessionsUpdateTrigger.add(true);
  }

  void updateAccount() {
    updateAccountTrigger.add(true);
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void updateAuth(bool isAuth) {
    emit(state.copyWith(isAuth: isAuth));
  }

  void goToSupport(BuildContext context) {
    context.push(route: const FortunicaSupport());
  }
}
