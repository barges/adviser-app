import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/app_success/app_success.dart';
import 'package:shared_advisor_interface/data/models/enums/validation_error_type.dart';
import 'package:shared_advisor_interface/data/network/responses/login_response.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/di/modules/api_module.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_state.dart';
import 'package:shared_advisor_interface/presentation/services/dynamic_link_service.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;
  final CachingManager _cacheManager;
  final Dio _dio;

  final MainCubit _mainCubit;
  final DynamicLinkService _dynamicLinkService;

  late final List<Brand> unauthorizedBrands;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  LoginCubit(this._repository, this._cacheManager, this._mainCubit,
      this._dynamicLinkService, this._dio)
      : super(const LoginState()) {
    _dynamicLinkService.checkLinkForResetPassword();

    unauthorizedBrands = _cacheManager.getUnauthorizedBrands();
    final Brand? newSelectedBrand = Get.arguments;

    emit(state.copyWith(
      selectedBrand: newSelectedBrand ?? unauthorizedBrands.first,
    ));

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
    if (state.appSuccess is! EmptySuccess) {
      emit(
        state.copyWith(
          appSuccess: const EmptySuccess(),
        ),
      );
    }
  }

  Future<void> login() async {
    if (emailIsValid() && passwordIsValid()) {
      _dio.addAuthorizationToHeader(
          'Basic ${base64.encode(utf8.encode('${emailController.text}:${passwordController.text.to256}'))}');
      try {
        LoginResponse? response = await _repository.login();
        String? token = response?.accessToken;
        if (token != null && token.isNotEmpty) {
          String jvtToken = 'JWT $token';
          await _cacheManager.saveTokenForBrand(state.selectedBrand, jvtToken);
          _dio.addAuthorizationToHeader(jvtToken);
          _cacheManager.saveCurrentBrand(state.selectedBrand);
          goToHome();
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

  void goToHome() {
    Get.offNamedUntil(AppRoutes.home, (_) => false);
  }

  Future<void> goToForgotPassword({Brand? brand, String? token}) async {
    clearErrorMessage();
    clearSuccessMessage();

    Get.toNamed(
      AppRoutes.forgotPassword,
      arguments: ForgotPasswordScreenArguments(
        brand: state.selectedBrand,
      ),
    );
  }

  void updateSuccessMessage(AppSuccess appSuccess) {
    emit(
      state.copyWith(appSuccess: appSuccess),
    );
    logger.d(state.appSuccess);
  }

  bool emailIsValid() => GetUtils.isEmail(emailController.text);

  bool passwordIsValid() => passwordController.text.length >= 6;
}
