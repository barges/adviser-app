import 'dart:async';

import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/app_success/app_success.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/data/network/requests/login_request.dart';
import 'package:zodiac/data/network/responses/login_response.dart';
import 'package:zodiac/domain/repositories/auth_repository.dart';
import 'package:zodiac/presentation/screens/login/login_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class LoginCubit extends Cubit<LoginState> {
  final AppRouter _routerService;
  final AuthRepository _repository;
  final ZodiacCachingManager _cachingManager;

  final ZodiacMainCubit _zodiacMainCubit;

  //final DynamicLinkService _dynamicLinkService;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  LoginCubit(
    this._routerService,
    this._repository,
    this._cachingManager,
    this._zodiacMainCubit,
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
        final LoginRequest loginRequest = LoginRequest(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        logger.d(loginRequest);
        LoginResponse? response = await _repository.login(
            request: loginRequest);

        String? token = response?.result?.authToken;
        if (token != null && token.isNotEmpty) {
          await _cachingManager.saveUserToken(token);
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
    context.replaceAll([const ZodiacMain()]);
  }

  Future<void> goToForgotPassword({Brand? brand, String? token}) async {
    clearErrorMessage();
    clearSuccessMessage();

    // final dynamic email = await Get.toNamed(
    //   AppRoutes.forgotPassword,
    //   arguments: ForgotPasswordScreenArguments(
    //     brand: state.selectedBrand,
    //   ),
    // );
    //
    // if (email != null) {
    //   emit(
    //     state.copyWith(
    //       appSuccess: UISuccess.withArguments(
    //           UISuccessMessagesType.weVeSentPasswordResetInstructionsToEmail,
    //           email as String),
    //     ),
    //   );
    // }
  }

  bool emailIsValid() => Utils.isEmail(emailController.text);

  bool passwordIsValid() => passwordController.text.length >= 8;
}