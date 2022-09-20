import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/network/responses/login_response.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;
  final CacheManager _cacheManager;

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final FocusNode passwordNode = FocusNode();

  LoginCubit(this._repository, this._cacheManager) : super(const LoginState()) {
    final List<Brand> unauthorizedBrands =
        _cacheManager.getUnauthorizedBrands();
    final Brand? newSelectedBrand = Get.arguments;

    emit(state.copyWith(
      unauthorizedBrands: unauthorizedBrands,
      selectedBrand: newSelectedBrand ?? unauthorizedBrands.first,
    ));

    emailController.addListener(() {
      emit(state.copyWith(
        emailErrorText: '',
        errorMessage: '',
        successMessage: '',
        showOpenEmailButton: false,
      ));
    });
    passwordController.addListener(() {
      emit(state.copyWith(
        passwordErrorText: '',
        errorMessage: '',
        successMessage: '',
        showOpenEmailButton: false,
      ));
    });
  }

  void setSelectedBrand(Brand brand) {
    emit(state.copyWith(selectedBrand: brand));
  }

  void showHidePassword() {
    emit(state.copyWith(hiddenPassword: !state.hiddenPassword));
  }

  void clearErrorMessage() {
    if (state.errorMessage.isNotEmpty) {
      emit(state.copyWith(errorMessage: ''));
    }
  }

  void clearSuccessMessage() {
    if (state.successMessage.isNotEmpty) {
      emit(state.copyWith(
        successMessage: '',
        showOpenEmailButton: false,
      ));
    }
  }

  Future<void> login(BuildContext context) async {
    if (emailIsValid() && passwordIsValid()) {
      Get.find<Dio>().options.headers['Authorization'] =
          'Basic ${base64.encode(utf8.encode('${emailController.text}:${passwordController.text.to256}'))}';
      try {
        LoginResponse? response = await run(_repository.login());
        String? token = response?.accessToken;
        if (token != null && token.isNotEmpty) {
          String jvtToken = 'JWT $token';
          await _cacheManager.saveTokenForBrand(state.selectedBrand, jvtToken);
          Get.find<Dio>().options.headers['Authorization'] = jvtToken;
          _cacheManager.saveCurrentBrand(state.selectedBrand);
          goToHome();
        }
      } on DioError catch (e) {
        if (e.response?.statusCode != 401) {
          emit(
            state.copyWith(
              errorMessage: e.response?.data['status'] ?? '',
            ),
          );
        } else {
          emit(state.copyWith(
            errorMessage: S.of(context).wrongUsernameOrPassword,
          ));
        }
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
    }
  }

  void setSuccessMessage(BuildContext context, {bool showEmailButton = false}) {
    if (state.successMessage.isEmpty) {
      emit(state.copyWith(
        successMessage: S
            .of(context)
            .youHaveSuccessfullyChangedYourPasswordCheckYourEmailTo,
        showOpenEmailButton: showEmailButton,
      ));
    }
  }

  void goToHome() {
    Get.offNamedUntil(AppRoutes.home, (_) => false);
  }

  Future<void> goToForgotPassword(BuildContext context,
      [bool mounted = true]) async {
    final dynamic showEmailMessage = (await Get.toNamed(
        AppRoutes.forgotPassword,
        arguments: state.selectedBrand));
    if (!mounted) return;
    if (showEmailMessage is bool && showEmailMessage == true) {
      emit(state.copyWith(
          successMessage: S
              .of(context)
              .youHaveSuccessfullyChangedYourPasswordCheckYourEmailTo,
          showOpenEmailButton: showEmailMessage));
    }
  }

  bool emailIsValid() => GetUtils.isEmail(emailController.text);

  bool passwordIsValid() => passwordController.text.length >= 8;
}
