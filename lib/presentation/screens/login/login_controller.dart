import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/network/responses/login_response.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/base_screen/runnable_controller.dart';

class LoginController extends RunnableController {
  final AuthRepository _repository;

  LoginController(this._repository, CacheManager cacheManager)
      : super(cacheManager);

  final Rx<Brand> selectedBrand = Brand.fortunica.obs;

  late List<Brand> unauthorizedBrands;

  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;
  bool showOpenEmailButton = false;

  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxBool hiddenPassword = true.obs;

  int index = 0;

  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    unauthorizedBrands = cacheManager.getUnauthorizedBrands();
    final Brand? newSelectedBrand = Get.arguments;
    selectedBrand.value = newSelectedBrand ?? unauthorizedBrands.first;
    ever(email, (_) {
      clearSuccessMessage();
      clearErrorMessage();
    });
    ever(password, (_) {
      clearSuccessMessage();
      clearErrorMessage();
    });
    index = cacheManager.getLocaleIndex() ?? 0;
    emailController.addListener(() {
      email.value = emailController.text;
    });
    passwordController.addListener(() {
      password.value = passwordController.text;
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login(BuildContext context) async {
    if (emailIsValid() && passwordIsValid()) {
      Get.find<Dio>().options.headers['Authorization'] =
          'Basic ${base64.encode(utf8.encode('${email.value}:${password.value.to256}'))}';
      try {
        // return _cacheManager.isLoggedIn() ?? false;

        LoginResponse? response = await run(_repository.login());
        String? token = response?.accessToken;
        if (token != null && token.isNotEmpty) {
          String jvtToken = 'JWT $token';
          await cacheManager.saveTokenForBrand(selectedBrand.value, jvtToken);
          Get.find<Dio>().options.headers['Authorization'] = jvtToken;
          cacheManager.saveCurrentBrand(selectedBrand.value);
          goToHome();
        }
      } on DioError catch (e) {
        if (e.response?.statusCode != 401) {
          errorMessage.value = e.response?.data['status'] ?? '';
        } else {
          errorMessage.value = S.of(context).wrongUsernameOrPassword;
        }
      }
    }
  }

  void changeLocale() {
    Locale locale;
    if (index < S.delegate.supportedLocales.length - 1) {
      locale = S.delegate.supportedLocales[++index];
      Get.updateLocale(
          Locale(locale.languageCode, locale.languageCode.toUpperCase()));
    } else {
      index = 0;
      locale = S.delegate.supportedLocales[index];
      Get.updateLocale(
          Locale(locale.languageCode, locale.languageCode.toUpperCase()));
    }
    cacheManager.saveLocaleIndex(index);
  }

  void clearErrorMessage() {
    if (errorMessage.value.isNotEmpty) {
      errorMessage.value = '';
    }
  }

  void clearSuccessMessage() {
    if (successMessage.value.isNotEmpty) {
      successMessage.value = '';
      showOpenEmailButton = false;
    }
  }

  void setSuccessMessage(BuildContext context, {bool showEmailButton = false}) {
    if (successMessage.value.isEmpty) {
      successMessage.value =
          S.of(context).youHaveSuccessfullyChangedYourPasswordCheckYourEmailTo;
      showOpenEmailButton = showEmailButton;
    }
  }

  void goToHome() {
    Get.offNamedUntil(AppRoutes.home, (_) => false);
  }

  void goToForgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword, arguments: selectedBrand.value);
  }

  bool emailIsValid() => GetUtils.isEmail(email.value);

  bool passwordIsValid() => password.value.length >= 8;
}
