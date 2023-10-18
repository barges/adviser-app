import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../extensions.dart';
import '../../../../infrastructure/routing/app_router.dart';
import '../../../data/models/app_success/app_success.dart';
import '../../../data/models/app_success/ui_success_type.dart';
import '../../../data/models/enums/validation_error_type.dart';
import '../../../data/network/requests/reset_password_request.dart';
import '../../../domain/repositories/fortunica_auth_repository.dart';
import '../../../main_cubit.dart';
import '../../../services/dynamic_link_service.dart';
import '../../../utils/utils.dart';
import '../login/login_cubit.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final FortunicaAuthRepository authRepository;
  final DynamicLinkService dynamicLinkService;
  final MainCubit mainCubit;
  final LoginCubit loginCubit;
  final String? resetToken;

  late final StreamSubscription<DynamicLinkData> _linkSubscription;

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  ForgotPasswordCubit({
    required this.authRepository,
    required this.dynamicLinkService,
    required this.mainCubit,
    required this.loginCubit,
    this.resetToken,
  }) : super(const ForgotPasswordState()) {
    if (resetToken != null) {
      updateResetToken(
        token: resetToken,
      );
      _verifyToken(resetToken);
    }

    _linkSubscription =
        dynamicLinkService.dynamicLinksStream.listen((dynamicLinkData) {
      if (dynamicLinkData.token != null) {
        updateResetToken(
          token: dynamicLinkData.token,
        );
        _verifyToken(dynamicLinkData.token);
      }
    });

    emailNode.addListener(() {
      emit(state.copyWith(emailHasFocus: emailNode.hasFocus));
    });

    emailController.addListener(() {
      clearErrorMessage();
      emit(state.copyWith(
        emailErrorType: ValidationErrorType.empty,
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
        passwordErrorType: ValidationErrorType.empty,
        isButtonActive: passwordController.text.isNotEmpty &&
            confirmPasswordController.text.isNotEmpty,
      ));
    });

    confirmPasswordController.addListener(() {
      clearErrorMessage();
      emit(state.copyWith(
        confirmPasswordErrorType: ValidationErrorType.empty,
        isButtonActive: passwordController.text.isNotEmpty &&
            confirmPasswordController.text.isNotEmpty,
      ));
    });
  }

  @override
  Future<void> close() async {
    _linkSubscription.cancel();
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

  void updateResetToken({String? token}) {
    emit(
      state.copyWith(
        resetToken: token,
      ),
    );
  }

  Future<void> resetPassword(BuildContext context, String? resetToken) async {
    if (resetToken == null) {
      await sendEmailForReset(context);
    } else {
      await changePassword();
    }
  }

  Future<void> sendEmailForReset(BuildContext context) async {
    if (emailIsValid()) {
      final bool success = await authRepository.sendEmailForReset(
        ResetPasswordRequest(
          email: emailController.text,
        ),
      );
      if (success) {
        loginCubit.updateSuccessMessage(
          UISuccess.withArguments(
            UISuccessMessagesType.weVeSentPasswordResetInstructionsToEmail,
            emailController.text,
          ),
        );
        // ignore: use_build_context_synchronously
        context.pop();
      }
    } else {
      emit(
        state.copyWith(
            emailErrorType: ValidationErrorType.pleaseInsertCorrectEmail),
      );
    }
  }

  Future<void> _verifyToken(String? token) async {
    try {
      await authRepository.verifyToken(token: token ?? '');
    } on DioError catch (e) {
      _checkErrorForReset(e);
    }
  }

  Future<void> changePassword() async {
    try {
      if (passwordIsValid() && confirmPasswordIsValid()) {
        final bool success = await authRepository.sendPasswordForReset(
          request: ResetPasswordRequest(
            password: passwordController.text.to256,
          ),
          token: state.resetToken ?? '',
        );
        if (success) {
          loginCubit.clearSuccessMessage();
          emit(state.copyWith(isResetSuccess: true));
        }
      } else {
        if (!passwordIsValid()) {
          emit(
            state.copyWith(
              passwordErrorType:
                  ValidationErrorType.pleaseEnterAtLeast6Characters,
            ),
          );
        }
        if (!confirmPasswordIsValid()) {
          emit(
            state.copyWith(
              confirmPasswordErrorType:
                  ValidationErrorType.thePasswordsMustMatch,
            ),
          );
        }
      }
    } on DioError catch (e) {
      _checkErrorForReset(e);
    }
  }

  void _checkErrorForReset(DioError error) {
    if (error.response?.statusCode == 400 ||
        error.response?.statusCode == 404 ||
        error.response?.statusCode == 403) {
      updateResetToken(
        token: null,
      );
    }
  }

  void clearErrorMessage() {
    mainCubit.clearErrorMessage();
  }

  bool emailIsValid() => Utils.isEmail(emailController.text);

  bool passwordIsValid() => passwordController.text.length >= 6;

  bool confirmPasswordIsValid() =>
      passwordController.text == confirmPasswordController.text;
}
