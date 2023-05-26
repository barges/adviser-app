import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:zodiac/data/network/requests/phone_number_verify_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/phone_number_verify_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/sms_verification/sms_verification_state.dart';

const inactiveResendCodeDurationInSec = 30;

class SMSVerificationCubitCubit extends Cubit<SMSVerificationState> {
  final MainCubit _globalMainCubit;
  final ZodiacUserRepository _zodiacUserRepository;
  final ConnectivityService _connectivityService;
  final GlobalCachingManager _cacheManager;
  final TextEditingController verificationCodeInputController =
      TextEditingController();
  final codeTextFieldFocus = FocusNode();

  late final StreamSubscription<bool> _appLifecycleSubscription;
  Timer? _inactiveResendCodeTimer;
  SMSVerificationCubitCubit(
    this._globalMainCubit,
    this._zodiacUserRepository,
    this._connectivityService,
    this._cacheManager,
  ) : super(const SMSVerificationState()) {
    codeTextFieldFocus.addListener(() {
      if (state.isError && codeTextFieldFocus.hasPrimaryFocus) {
        emit(state.copyWith(
          isError: false,
        ));
      }
    });

    _appLifecycleSubscription =
        _globalMainCubit.changeAppLifecycleStream.listen(
      (value) {
        if (value) {
          _checkTimingInactiveResendCode();
        } else {
          _inactiveResendCodeTimer?.cancel();
        }
      },
    );

    _checkTimingInactiveResendCode();
  }

  @override
  Future<void> close() {
    verificationCodeInputController.dispose();
    codeTextFieldFocus.dispose();
    _inactiveResendCodeTimer?.cancel();
    _appLifecycleSubscription.cancel();
    return super.close();
  }

  void _checkTimingInactiveResendCode() {
    final startTimeInactiveResendCode =
        _cacheManager.getStartTimeInactiveResendCode();
    if (startTimeInactiveResendCode != null) {
      final Duration durationInactiveResendCode =
          DateTime.now().difference(startTimeInactiveResendCode);
      if (durationInactiveResendCode.inSeconds >
          inactiveResendCodeDurationInSec) {
        updateResendCodeButtonEnabled(true);
      } else {
        updateResendCodeButtonEnabled(false);
        _startInactiveResendCodeTimer(Duration(
            seconds: inactiveResendCodeDurationInSec -
                durationInactiveResendCode.inSeconds));
      }
    }
  }

  Future<bool> verifyPhoneNumber() async {
    codeTextFieldFocus.unfocus();
    try {
      if (await _connectivityService.checkConnection()) {
        final PhoneNumberVerifyResponse response = await _zodiacUserRepository
            .verifyPhoneNumber(PhoneNumberVerifyRequest(
          code: int.parse(verificationCodeInputController.text),
          captchaResponse: 'captcha_response_success',
        ));

        if (response.status == false && response.errorCode != null) {
          emit(state.copyWith(
            isError: true,
          ));
        }

        return response.status == true && response.isVerified == true;
      }
    } catch (e) {
      logger.d(e);
    }

    return false;
  }

  Future<bool> resendCode() async {
    bool isSuccess = await _resendPhoneVerification();
    if (isSuccess) {
      _startInactiveResendCodeTimer();
      updateResendCodeButtonEnabled(false);
      verificationCodeInputController.clear();
      if (state.isError) {
        emit(state.copyWith(
          isError: false,
        ));
      }
    }
    return isSuccess;
  }

  Future<bool> _resendPhoneVerification() async {
    try {
      if (await _connectivityService.checkConnection()) {
        final BaseResponse response = await _zodiacUserRepository
            .resendPhoneVerification(PhoneNumberVerifyRequest(
          captchaResponse: 'captcha_response_success',
        ));

        return response.status == true;
      }
    } catch (e) {
      logger.d(e);
    }

    return false;
  }

  _startInactiveResendCodeTimer([Duration? duration]) {
    _inactiveResendCodeTimer?.cancel();
    if (duration == null) {
      _cacheManager.saveStartTimeInactiveResendCode(DateTime.now());
    }
    _inactiveResendCodeTimer = Timer(
        duration ?? const Duration(seconds: inactiveResendCodeDurationInSec),
        () {
      updateResendCodeButtonEnabled(true);
      _cacheManager.saveStartTimeInactiveResendCode(null);
    });
  }

  void updateVerifyButtonEnabled(bool value) {
    emit(state.copyWith(
      isVerifyButtonEnabled: value,
    ));
  }

  void updateResendCodeButtonEnabled(bool value) {
    emit(state.copyWith(
      isResendCodeButtonEnabled: value,
    ));
  }
}
