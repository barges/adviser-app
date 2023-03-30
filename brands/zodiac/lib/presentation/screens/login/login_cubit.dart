import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/app_success/app_success.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/data/network/requests/login_request.dart';
import 'package:zodiac/data/network/requests/update_locale_request.dart';
import 'package:zodiac/data/network/responses/login_response.dart';
import 'package:zodiac/domain/repositories/zodiac_auth_repository.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/login/login_state.dart';
import 'package:zodiac/zodiac.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class LoginCubit extends Cubit<LoginState> {
  final ZodiacAuthRepository _repository;
  final ZodiacCachingManager _cachingManager;
  final ZodiacUserRepository _userRepository;
  final ZodiacMainCubit _zodiacMainCubit;

  //final DynamicLinkService _dynamicLinkService;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  LoginCubit(
    this._repository,
    this._cachingManager,
    this._zodiacMainCubit,
    this._userRepository,

    //this._dynamicLinkService,
  ) : super(const LoginState()) {
    //_dynamicLinkService.checkLinkForResetPassword();

    emailNode.addListener(() {
      emit(state.copyWith(emailHasFocus: emailNode.hasFocus));
    });

    passwordNode.addListener(() {
      emit(state.copyWith(passwordHasFocus: passwordNode.hasFocus));
    });

    emailController.addListener(() {
      clearErrorMessage();
      clearSuccessMessage();
      emit(state.copyWith(
          emailErrorType: ValidationErrorType.empty,
          buttonIsActive: emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty));
    });
    passwordController.addListener(() {
      clearErrorMessage();
      clearSuccessMessage();
      emit(state.copyWith(
          passwordErrorType: ValidationErrorType.empty,
          buttonIsActive: passwordController.text.isNotEmpty &&
              emailController.text.isNotEmpty));
    });
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    return super.close();
  }

  void showHidePassword() {
    emit(state.copyWith(hiddenPassword: !state.hiddenPassword));
  }

  void updateSuccessMessage(AppSuccess appSuccess) {
    emit(state.copyWith(appSuccess: appSuccess));
  }

  void clearErrorMessage() {
    _zodiacMainCubit.clearErrorMessage();
  }

  void clearSuccessMessage() {
    if (state.appSuccess is! EmptySuccess) {
      emit(
        state.copyWith(
          appSuccess: const EmptySuccess(),
        ),
      );
    }
  }

  Future<void> login(BuildContext context) async {
    if (emailIsValid() && passwordIsValid()) {
      try {
        String languageCode = ZodiacBrand().languageCode ?? 'en';
        final LoginRequest loginRequest = LoginRequest(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          locale: languageCode,
        );
        logger.d('request: ${loginRequest.toJson()}');
        LoginResponse? response =
            await _repository.login(request: loginRequest);

        String? token = response?.result?.authToken;
        int? userId = response?.result?.id;

        if (response?.errorCode == 0 && token != null && userId != null) {
          await _cachingManager.saveUserToken(token);
          await _cachingManager.saveUid(userId);

          await _userRepository
              .updateLocale(UpdateLocaleRequest(locale: languageCode));

          goToHome(context);
        }
      } on DioError catch (e) {
        logger.d(e);
      }

      // try {
      //   LoginResponse? response = await _repository.login();
      //   String? token = response?.accessToken;
      //   if (token != null && token.isNotEmpty) {
      //     String jvtToken = 'JWT $token';
      //     await _globalCachingManager.saveTokenForBrand(
      //         state.selectedBrand, jvtToken);
      //     _globalCachingManager.saveCurrentBrand(state.selectedBrand);
      //     goToHome(context);
      //   }
      // } on DioError catch (e) {
      //   logger.d(e);
      // }
    } else {
      if (!emailIsValid()) {
        emit(
          state.copyWith(
              emailErrorType: ValidationErrorType.pleaseInsertCorrectEmail),
        );
      }
      if (!passwordIsValid()) {
        emit(
          state.copyWith(
            passwordErrorType:
                ValidationErrorType.pleaseEnterAtLeast8Characters,
          ),
        );
      }
    }
  }

  void goToHome(BuildContext context) {
    context.replaceAll([ZodiacHome()]);
  }

  void goToForgotPassword(BuildContext context) {
    clearErrorMessage();
    clearSuccessMessage();

    context.push(
      route: const ZodiacForgotPassword(),
    );
  }

  bool emailIsValid() => Utils.isEmail(emailController.text);

  bool passwordIsValid() => passwordController.text.length >= 8;
}
