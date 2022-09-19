import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/network/requests/reset_password_request.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
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
        email: emailController.text,
        errorMessage: '',
      ));
    });
    passwordController.addListener(() {
      emit(state.copyWith(
        password: passwordController.text,
        errorMessage: '',
      ));
    });

    confirmPasswordController.addListener(() {
      emit(state.copyWith(
        confirmPassword: confirmPasswordController.text,
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

  Future<void> resetPassword() async {
    if (emailIsValid() &&
        passwordIsValid() &&
        state.password == state.confirmPassword) {
      try {
        final bool success = await run(_repository.resetPassword(
            ResetPasswordRequest(
                email: state.email, password: state.confirmPassword.to256)));
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
    }
  }

  void clearErrorMessage() {
    if (state.errorMessage.isNotEmpty) {
      emit(state.copyWith(errorMessage: ''));
    }
  }

  bool emailIsValid() => GetUtils.isEmail(state.email);

  bool passwordIsValid() => state.password.length >= 8;

  bool confirmPasswordIsValid() => state.password == state.confirmPassword;
}
