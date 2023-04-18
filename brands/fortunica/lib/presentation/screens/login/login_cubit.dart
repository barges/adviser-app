import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/data/models/app_success/app_success.dart';
import 'package:fortunica/data/models/app_success/ui_success_type.dart';
import 'package:fortunica/data/models/enums/validation_error_type.dart';
import 'package:fortunica/data/network/responses/login_response.dart';
import 'package:fortunica/domain/repositories/fortunica_auth_repository.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/infrastructure/di/modules/api_module.dart';
import 'package:fortunica/presentation/screens/login/login_state.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/utils/utils.dart';

class LoginCubit extends Cubit<LoginState> {
  final FortunicaAuthRepository _repository;
  final FortunicaCachingManager _cachingManager;
  final Dio _dio;
  final BrandManager _brandManager;

  final FortunicaMainCubit _fortunicaMainCubit;

  late final List<BaseBrand> unauthorizedBrands;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  LoginCubit(
    this._repository,
    this._cachingManager,
    this._fortunicaMainCubit,
    this._dio,
    this._brandManager,
  ) : super(const LoginState()) {
    unauthorizedBrands = BrandManager.unauthorizedBrands();

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
    _fortunicaMainCubit.clearErrorMessage();
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
          await _brandManager.saveAuthorizedBrands();
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
