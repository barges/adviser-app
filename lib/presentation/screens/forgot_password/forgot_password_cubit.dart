import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/network/requests/reset_password_request.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _repository;

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  late final Brand selectedBrand;

  ForgotPasswordCubit(this._repository) : super(const ForgotPasswordState()) {
    selectedBrand = Get.arguments as Brand;

    emailController.addListener(() {
      emit(state.copyWith(
        emailErrorText: '',
        errorMessage: '',
      ));
    });
    passwordController.addListener(() {
      emit(state.copyWith(
        passwordErrorText: '',
        errorMessage: '',
      ));
    });

    confirmPasswordController.addListener(() {
      emit(state.copyWith(
        confirmPasswordErrorText: '',
        errorMessage: '',
      ));
    });
  }

  void showHidePassword() {
    emit(state.copyWith(hiddenPassword: !state.hiddenPassword));
  }

  void showHideConfirmPassword() {
    emit(state.copyWith(hiddenConfirmPassword: !state.hiddenConfirmPassword));
  }

  Future<void> resetPassword(BuildContext context) async {
    if (emailIsValid() && passwordIsValid() && confirmPasswordIsValid()) {
      try {
        final bool success = await run(_repository.resetPassword(
            ResetPasswordRequest(
                email: emailController.text,
                password: passwordController.text.to256)));
        if (success) {
          Get.back(result: true);
        }
      } on DioError catch (e) {
        emit(state.copyWith(
          errorMessage: e.response?.data['status'] ?? 'Unknown dio error',
        ));
      } catch (e) {
        emit(state.copyWith(
          errorMessage: 'ERROR: $e',
        ));
        logger.d('ERROR: $e');
      }
    } else {
      if (!emailIsValid()) {
        emit(
          state.copyWith(
              emailErrorText: S.of(context).pleaseInsertCorrectEmail),
        );
      }
      if (!passwordIsValid()) {
        emit(
          state.copyWith(
            passwordErrorText: S.of(context).pleaseEnterAtLeast8Characters,
          ),
        );
      }
      if (!confirmPasswordIsValid()) {
        emit(
          state.copyWith(
            confirmPasswordErrorText: S.of(context).thePasswordsMustMatch,
          ),
        );
      }
    }
  }

  void clearErrorMessage() {
    if (state.errorMessage.isNotEmpty) {
      emit(state.copyWith(errorMessage: ''));
    }
  }

  bool emailIsValid() => GetUtils.isEmail(emailController.text);

  bool passwordIsValid() => passwordController.text.length >= 8;

  bool confirmPasswordIsValid() =>
      passwordController.text == confirmPasswordController.text;
}
