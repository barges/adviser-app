import 'dart:async';
import 'dart:core';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:zodiac/data/models/enums/recaptcha_custom_action.dart';
import 'package:zodiac/data/network/requests/phone_number_verify_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/phone_number_verify_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/sms_verification/sms_verification_state.dart';
import 'package:zodiac/services/recaptcha/recaptcha_service.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

const verificationCodeInputFieldCount = 4;
const inactiveResendCodeDurationInSec = 30;

class SMSVerificationCubitCubit extends Cubit<SMSVerificationState> {
  final MainCubit _globalMainCubit;
  final ZodiacMainCubit _zodiacMainCubit;
  final ZodiacUserRepository _zodiacUserRepository;
  final ConnectivityService _connectivityService;
  final GlobalCachingManager _cacheManager;
  final TextEditingController verificationCodeInputController =
      TextEditingController();
  final codeTextFieldFocus = FocusNode();

  late final StreamSubscription<bool> _appLifecycleSubscription;
  StreamSubscription<bool>? _connectivitySubscription;

  Timer? _inactiveResendCodeTimer;
  int _codeTextFieldFilled = 0;

  SMSVerificationCubitCubit(
    this._globalMainCubit,
    this._zodiacMainCubit,
    this._zodiacUserRepository,
    this._connectivityService,
    this._cacheManager,
  ) : super(const SMSVerificationState()) {
    _init();
  }

  @override
  Future<void> close() {
    verificationCodeInputController.dispose();
    codeTextFieldFocus.dispose();
    _inactiveResendCodeTimer?.cancel();
    _appLifecycleSubscription.cancel();
    _connectivitySubscription?.cancel();
    return super.close();
  }

  _init() async {
    codeTextFieldFocus.addListener(() {
      if (state.isError && codeTextFieldFocus.hasPrimaryFocus) {
        emit(state.copyWith(
          isError: false,
        ));
      }
    });

    _checkTimingInactiveResendCode();

    _appLifecycleSubscription =
        _globalMainCubit.changeAppLifecycleStream.listen(
      (value) {
        if (value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(const Duration(milliseconds: 500),
                () => codeTextFieldFocus.requestFocus());
          });
          _checkTimingInactiveResendCode();
        } else {
          codeTextFieldFocus.unfocus();
          _inactiveResendCodeTimer?.cancel();
        }
      },
    );
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
      final token =
          await RecaptchaService.execute(RecaptchaCustomAction.phoneVerifyCode);

      final PhoneNumberVerifyResponse response = await _zodiacUserRepository
          .verifyPhoneNumber(PhoneNumberVerifyRequest(
        code: int.parse(verificationCodeInputController.text),
        captchaResponse: token,
      ));

      if (response.isVerified == false) {
        emit(state.copyWith(
          isError: true,
        ));
      }

      return response.status == true && response.isVerified == true;
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

  void clearErrorMessage() {
    _zodiacMainCubit.clearErrorMessage();
  }

  Future<bool> _resendPhoneVerification() async {
    try {
      if (await _connectivityService.checkConnection()) {
        final token = await RecaptchaService.execute(
            RecaptchaCustomAction.phoneResendCode);

        final BaseResponse response = await _zodiacUserRepository
            .resendPhoneVerification(PhoneNumberVerifyRequest(
          captchaResponse: token,
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

  void updateVerifyButtonEnabled(int codeTextFieldFilled) {
    _codeTextFieldFilled = codeTextFieldFilled;
    emit(state.copyWith(
      isVerifyButtonEnabled:
          _codeTextFieldFilled == verificationCodeInputFieldCount,
    ));
  }

  void updateResendCodeButtonEnabled(bool value) {
    emit(state.copyWith(
      isResendCodeButtonEnabled: value,
    ));
  }
}
