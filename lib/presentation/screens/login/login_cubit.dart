import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../extensions.dart';
import '../../../infrastructure/di/modules/api_module.dart';
import '../../../infrastructure/routing/app_router.dart';
import '../../../data/cache/caching_manager.dart';
import '../../../data/models/app_success/app_success.dart';
import '../../../data/models/app_success/ui_success_type.dart';
import '../../../data/models/enums/validation_error_type.dart';
import '../../../data/network/responses/login_response.dart';
import '../../../domain/repositories/fortunica_auth_repository.dart';
import '../../../global.dart';
import '../../../infrastructure/routing/app_router.gr.dart';
import '../../../main_cubit.dart';
import '../../../utils/utils.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FortunicaAuthRepository _repository;
  final CachingManager _cachingManager;
  final Dio _dio;
  final MainCubit _mainCubit;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  LoginCubit(
    this._repository,
    this._cachingManager,
    this._mainCubit,
    this._dio,
  ) : super(const LoginState()) {
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
    _mainCubit.clearErrorMessage();
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
      _dio.addAuthorizationToHeader(
          'Basic ${base64.encode(utf8.encode('${emailController.text}:${passwordController.text.to256}'))}');
      try {
        LoginResponse? response = await _repository.login();
        String? token = response?.accessToken;
        if (token != null && token.isNotEmpty) {
          String jvtToken = 'JWT $token';
          await _cachingManager.saveUserToken(jvtToken);
          _dio.addAuthorizationToHeader(jvtToken);
          _mainCubit.updateAuth(true);
          // ignore: use_build_context_synchronously
          goToHome(context);
        }
      } on DioError catch (e) {
        logger.d(e);
      }
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
                ValidationErrorType.pleaseEnterAtLeast6Characters,
          ),
        );
      }
    }
  }

  void goToHome(BuildContext context) {
    context.replaceAll([FortunicaHome()]);
  }

  Future<void> goToForgotPassword(BuildContext context) async {
    clearErrorMessage();
    clearSuccessMessage();

    final dynamic email = await context.push(
      route: FortunicaForgotPassword(),
    );

    if (email != null) {
      emit(
        state.copyWith(
          appSuccess: UISuccess.withArguments(
              UISuccessMessagesType.weVeSentPasswordResetInstructionsToEmail,
              email as String),
        ),
      );
    }
  }

  void updateSuccessMessage(AppSuccess appSuccess) {
    emit(
      state.copyWith(appSuccess: appSuccess),
    );
  }

  bool emailIsValid() => Utils.isEmail(emailController.text);

  bool passwordIsValid() => passwordController.text.length >= 6;
}
