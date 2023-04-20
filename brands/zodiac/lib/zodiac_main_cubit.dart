import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/zodiac_main_state.dart';

@singleton
class ZodiacMainCubit extends Cubit<ZodiacMainState> {
  final ConnectivityService _connectivityService;

  Timer? _errorTimer;

  final PublishSubject<bool> sessionsUpdateTrigger = PublishSubject();
  final PublishSubject<bool> audioStopTrigger = PublishSubject();
  final PublishSubject<UserBalance> userBalanceUpdateTrigger = PublishSubject();
  final PublishSubject<bool> articleCountUpdateTrigger = PublishSubject();
  final PublishSubject<bool> articleUpdateTrigger = PublishSubject();
  final PublishSubject<bool> accountUpdateTrigger = PublishSubject();
  final PublishSubject<bool> unreadNotificationsCounterUpdateTrigger =
      PublishSubject();
  final PublishSubject<bool> updateNotificationsListTrigger = PublishSubject();

  late final StreamSubscription _connectivitySubscription;

  ZodiacMainCubit(this._connectivityService) : super(const ZodiacMainState()) {
    _connectivitySubscription =
        _connectivityService.connectivityStream.listen((event) {
      if (!event) {
        clearErrorMessage();
      }
    });
  }

  @override
  Future<void> close() {
    _errorTimer?.cancel();
    _connectivitySubscription.cancel();
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

  void updateSessions() {
    sessionsUpdateTrigger.add(true);
  }

  void stopAudio() {
    audioStopTrigger.add(true);
  }

  void updateUserBalance(UserBalance userBalance) {
    userBalanceUpdateTrigger.add(userBalance);
  }

  void updateArticleCount() {
    articleCountUpdateTrigger.add(true);
  }

  void updateArticle() {
    articleUpdateTrigger.add(true);
  }

  void updateAccount() {
    accountUpdateTrigger.add(true);
  }

  void updateUnreadNotificationsCounter() {
    unreadNotificationsCounterUpdateTrigger.add(true);
  }

  void updateNotificationsList() {
    updateNotificationsListTrigger.add(true);
  }
}
