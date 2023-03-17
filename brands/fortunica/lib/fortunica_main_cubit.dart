import 'dart:async';

import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/fortunica_main_state.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@singleton
class FortunicaMainCubit extends Cubit<FortunicaMainState> {

  Timer? _errorTimer;

  final PublishSubject<bool> sessionsUpdateTrigger = PublishSubject();
  final PublishSubject<bool> updateAccountTrigger = PublishSubject();

  FortunicaMainCubit()
      : super(const FortunicaMainState());

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

  void updateAccount() {
    updateAccountTrigger.add(true);
  }
}
