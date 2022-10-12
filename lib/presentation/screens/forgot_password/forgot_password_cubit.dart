import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/network/requests/reset_password_request.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _repository;

  final MainCubit _mainCubit = Get.find<MainCubit>();

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  late final Brand selectedBrand;

  ForgotPasswordCubit(this._repository) : super(const ForgotPasswordState()) {
    selectedBrand = Get.arguments as Brand;

    emailController.addListener(() {
      clearErrorMessage();
      emit(state.copyWith(
        emailErrorText: '',
      ));
    });
    passwordController.addListener(() {
      clearErrorMessage();
      emit(state.copyWith(
        passwordErrorText: '',
      ));
    });

    confirmPasswordController.addListener(() {
      clearErrorMessage();
      emit(state.copyWith(
        confirmPasswordErrorText: '',
      ));
    });
  }

  @override
  Future<void> close() async {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }

  void showHidePassword() {
    emit(state.copyWith(hiddenPassword: !state.hiddenPassword));
  }

  void showHideConfirmPassword() {
    emit(state.copyWith(hiddenConfirmPassword: !state.hiddenConfirmPassword));
  }

  Future<void> resetPassword() async {
    if (emailIsValid() && passwordIsValid() && confirmPasswordIsValid()) {
      final bool success = await _repository.resetPassword(
        ResetPasswordRequest(
            email: emailController.text,
            password: passwordController.text.to256),
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
      if (!passwordIsValid()) {
        emit(
          state.copyWith(
            passwordErrorText: S.current.pleaseEnterAtLeast8Characters,
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
  }

  void clearErrorMessage() {
    _mainCubit.clearErrorMessage();
  }

  bool emailIsValid() => GetUtils.isEmail(emailController.text);

  bool passwordIsValid() => passwordController.text.length >= 8;

  bool confirmPasswordIsValid() =>
      passwordController.text == confirmPasswordController.text;
}
