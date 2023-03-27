import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/zodiac_main_state.dart';

@singleton
class ZodiacMainCubit extends Cubit<ZodiacMainState> {

  Timer? _errorTimer;

  final PublishSubject<bool> sessionsUpdateTrigger = PublishSubject();
  final PublishSubject<bool> audioStopTrigger = PublishSubject();
  final PublishSubject<UserBalance> userBalanceUpdateTrigger = PublishSubject();
  final PublishSubject<bool> articleCountUpdateTrigger = PublishSubject();

  ZodiacMainCubit()
      : super(const ZodiacMainState());

  @override
  Future<void> close() {
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
}
