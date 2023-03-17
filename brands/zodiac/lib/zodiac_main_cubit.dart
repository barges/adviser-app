import 'dart:async';

import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zodiac/zodiac_main_state.dart';

@singleton
class ZodiacMainCubit extends Cubit<ZodiacMainState> {
  final GlobalCachingManager cacheManager;

  Timer? _errorTimer;

  final PublishSubject<bool> sessionsUpdateTrigger = PublishSubject();
  final PublishSubject<bool> audioStopTrigger = PublishSubject();

  final ConnectivityService _connectivityService;

  ZodiacMainCubit(this.cacheManager, this._connectivityService)
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
}