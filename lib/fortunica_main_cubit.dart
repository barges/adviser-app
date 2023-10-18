/*import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'data/cache/fortunica_caching_manager.dart';
import 'fortunica_main_state.dart';

@singleton
class FortunicaMainCubit extends Cubit<FortunicaMainState> {
  final FortunicaCachingManager cachingManager;
  Timer? _errorTimer;

  //final PublishSubject<bool> sessionsUpdateTrigger = PublishSubject();
  //final PublishSubject<bool> updateAccountTrigger = PublishSubject();

  FortunicaMainCubit({required this.cachingManager})
      : super(const FortunicaMainState());

  @override
  Future<void> close() {
    _errorTimer?.cancel();
    return super.close();
  }

  /*void updateErrorMessage(AppError appError) {
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
  }*/

  /*void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }*/

  /*void updateSessions() {
    sessionsUpdateTrigger.add(true);
  }

  void updateAccount() {
    updateAccountTrigger.add(true);
  }*/

  /*void updateAuth(bool isAuth) {
    emit(state.copyWith(isAuth: isAuth));
  }*/
}*/
