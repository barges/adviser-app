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
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;
  final CacheManager _cacheManager;

  final MainCubit _mainCubit = Get.find<MainCubit>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
      clearErrorMessage();
      clearSuccessMessage();
      emit(state.copyWith(
        emailErrorText: '',
        //showOpenEmailButton: false,
      ));
    });
    passwordController.addListener(() {
      clearErrorMessage();
      clearSuccessMessage();
      emit(state.copyWith(
        passwordErrorText: '',
        //showOpenEmailButton: false,
      ));
    });
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }

  void setSelectedBrand(Brand brand) {
    emit(state.copyWith(selectedBrand: brand));
  }

  void showHidePassword() {
    emit(state.copyWith(hiddenPassword: !state.hiddenPassword));
  }

  void clearErrorMessage() {
    _mainCubit.clearErrorMessage();
  }

  void clearSuccessMessage() {
    _mainCubit.clearSuccessMessage();
  }

  Future<void> login() async {
    if (emailIsValid() && passwordIsValid()) {
      Get.find<Dio>().options.headers['Authorization'] =
      'Basic ${base64.encode(utf8.encode('${emailController.text}:${passwordController.text.to256}'))}';

      LoginResponse? response = await _repository.login();
      String? token = response?.accessToken;
      if (token != null && token.isNotEmpty) {
        String jvtToken = 'JWT $token';
        await _cacheManager.saveTokenForBrand(state.selectedBrand, jvtToken);
        Get.find<Dio>().options.headers['Authorization'] = jvtToken;
        _cacheManager.saveCurrentBrand(state.selectedBrand);
        goToHome();
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
    }
  }

  void goToHome() {
    Get.offNamedUntil(AppRoutes.home, (_) => false);
  }

  Future<void> goToForgotPassword() async {
    clearErrorMessage();
    clearSuccessMessage();
    Get.toNamed(
      AppRoutes.forgotPassword,
      arguments: state.selectedBrand,
    );
  }

  bool emailIsValid() => GetUtils.isEmail(emailController.text);

  bool passwordIsValid() => passwordController.text.length >= 8;
}

