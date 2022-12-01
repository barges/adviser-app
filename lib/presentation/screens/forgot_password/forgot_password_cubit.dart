import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/network/requests/reset_password_request.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _repository;

  final MainCubit _mainCubit = getIt.get<MainCubit>();

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  late final ForgotPasswordScreenArguments arguments;

  ForgotPasswordCubit(this._repository) : super(const ForgotPasswordState()) {
    arguments = Get.arguments as ForgotPasswordScreenArguments;

    if (arguments.resetToken != null) {
      updateResetToken(arguments.resetToken);
      _verifyToken();
    }

    emailNode.addListener(() {
      emit(state.copyWith(emailHasFocus: emailNode.hasFocus));
    });

    emailController.addListener(() {
      clearErrorMessage();
      emit(state.copyWith(
        emailErrorText: '',
        isButtonActive: emailController.text.isNotEmpty,
      ));
    });

    passwordNode.addListener(() {
      emit(state.copyWith(passwordHasFocus: passwordNode.hasFocus));
    });

    confirmPasswordNode.addListener(() {
      emit(state.copyWith(
          confirmPasswordHasFocus: confirmPasswordNode.hasFocus));
    });

    passwordController.addListener(() {
      clearErrorMessage();
      emit(state.copyWith(
        passwordErrorText: '',
        isButtonActive: passwordController.text.isNotEmpty &&
            confirmPasswordController.text.isNotEmpty,
      ));
    });

    confirmPasswordController.addListener(() {
      clearErrorMessage();
      emit(state.copyWith(
        confirmPasswordErrorText: '',
        isButtonActive: passwordController.text.isNotEmpty &&
            confirmPasswordController.text.isNotEmpty,
      ));
    });
  }

  @override
  Future<void> close() async {
    emailController.dispose();
    emailNode.dispose();
    passwordController.dispose();
    passwordNode.dispose();
    confirmPasswordController.dispose();
    confirmPasswordNode.dispose();
    return super.close();
  }

  void showHidePassword() {
    emit(state.copyWith(hiddenPassword: !state.hiddenPassword));
  }

  void showHideConfirmPassword() {
    emit(state.copyWith(hiddenConfirmPassword: !state.hiddenConfirmPassword));
  }

  void updateResetToken(String? token) {
    emit(state.copyWith(resetToken: token));
  }

  Future<void> resetPassword(String? resetToken) async {
    if (resetToken == null) {
      await sendEmailForReset();
    } else {
      await changePassword();
    }
  }

  Future<void> sendEmailForReset() async {
    if (emailIsValid()) {
      final bool success = await _repository.sendEmailForReset(
        ResetPasswordRequest(
          email: emailController.text,
        ),
      );
      if (success) {
        Get.back(result: true);
      }
    } else {
      if (!emailIsValid()) {
        emit(
          state.copyWith(emailErrorText: S.current.pleaseInsertCorrectEmail),
        );
      }
    }
  }

  Future<void> _verifyToken() async {
    try {
      logger.d(arguments.resetToken);
      await _repository.verifyToken(token: arguments.resetToken ?? '');
    } on DioError catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 404) {
        updateResetToken(null);
      }
    }
  }

  Future<void> changePassword() async {
    try {
      if (passwordIsValid() && confirmPasswordIsValid()) {
        final bool success = await _repository.sendPasswordForReset(
          request: ResetPasswordRequest(
            password: passwordController.text.to256,
          ),
          token: arguments.resetToken ?? '',
        );
        if (success) {}
      } else {
        if (!passwordIsValid()) {
          emit(
            state.copyWith(
              passwordErrorText: S.current.pleaseEnterAtLeast6Characters,
            ),
          );
        }
        if (!confirmPasswordIsValid()) {
          emit(
            state.copyWith(
              confirmPasswordErrorText: S.current.thePasswordsMustMatch,
            ),
          );
        }
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        updateResetToken(null);
      }
    }
  }

  void clearErrorMessage() {
    _mainCubit.clearErrorMessage();
  }

  bool emailIsValid() => GetUtils.isEmail(emailController.text);

  bool passwordIsValid() => passwordController.text.length >= 6;

  bool confirmPasswordIsValid() =>
      passwordController.text == confirmPasswordController.text;
}
