import 'dart:async';

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
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_state.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/services/dynamic_link_service.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _repository;
  final BuildContext _context;

  final DynamicLinkService _dynamicLinkService =
      getIt.get<DynamicLinkService>();
  final MainCubit _mainCubit = getIt.get<MainCubit>();

  late final StreamSubscription<DynamicLinkData> _linkSubscription;

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  late final ForgotPasswordScreenArguments arguments;

  ForgotPasswordCubit(this._repository, this._context)
      : super(const ForgotPasswordState()) {
    arguments = Get.arguments as ForgotPasswordScreenArguments;

    if (arguments.resetToken != null) {
      updateResetTokenAndBrand(
        brand: arguments.brand,
        token: arguments.resetToken,
      );
      _verifyToken(arguments.resetToken);
    }

    _linkSubscription =
        _dynamicLinkService.dynamicLinksStream.listen((dynamicLinkData) {
      if (dynamicLinkData.token != null) {
        updateResetTokenAndBrand(
          brand: dynamicLinkData.brand,
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

  void updateResetTokenAndBrand({required Brand brand, String? token}) {
    emit(
      state.copyWith(
        selectedBrand: brand,
        resetToken: token,
      ),
    );
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
        logger.d(Get.previousRoute);
        Get.back(result: emailController.text);
      }
    } else {
      if (!emailIsValid()) {
        emit(
          state.copyWith(
              emailErrorText: S.of(_context).pleaseInsertCorrectEmail),
        );
      }
    }
  }

  Future<void> _verifyToken(String? token) async {
    try {
      logger.d(token);
      await _repository.verifyToken(token: token ?? '');
    } on DioError catch (e) {
      _checkErrorForReset(e);
    }
  }

  Future<void> changePassword() async {
    try {
      if (passwordIsValid() && confirmPasswordIsValid()) {
        final bool success = await _repository.sendPasswordForReset(
          request: ResetPasswordRequest(
            password: passwordController.text.to256,
          ),
          token: state.resetToken ?? '',
        );
        if (success) {
          emit(state.copyWith(isResetSuccess: true));
        }
      } else {
        if (!passwordIsValid()) {
          emit(
            state.copyWith(
              passwordErrorText: S.of(_context).pleaseEnterAtLeast6Characters,
            ),
          );
        }
        if (!confirmPasswordIsValid()) {
          emit(
            state.copyWith(
              confirmPasswordErrorText: S.of(_context).thePasswordsMustMatch,
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
      updateResetTokenAndBrand(
        brand: state.selectedBrand,
        token: null,
      );
    }
  }

  void clearErrorMessage() {
    _mainCubit.clearErrorMessage();
  }

  void goToLogin() {
    if (Get.previousRoute == AppRoutes.login) {
      Get.back();
    } else {
      Get.offNamed(AppRoutes.login);
    }
  }

  bool emailIsValid() => GetUtils.isEmail(emailController.text);

  bool passwordIsValid() => passwordController.text.length >= 6;

  bool confirmPasswordIsValid() =>
      passwordController.text == confirmPasswordController.text;
}
