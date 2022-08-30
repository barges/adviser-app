import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/runnable_screen/runnable_screen.dart';

class LoginController extends RunnableController {
  final AuthRepository _repository;
  final CacheManager _cacheManager;

  LoginController(this._repository, this._cacheManager);

  final Rx<Brand> selectedBrand = Brand.fortunica.obs;

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
    saveCurrentBrand(selectedBrand.value);
    ever(selectedBrand, (brand) {
      saveCurrentBrand(brand as Brand);
    });
    ever(email, (_) {
      clearSuccessMessage();
      clearErrorMessage();
    });
    ever(password, (_) {
      clearSuccessMessage();
      clearErrorMessage();
    });
    index = _cacheManager.getLocaleIndex() ?? 0;
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
        final bool isLoggedIn = await run(_repository.login());
        if (isLoggedIn) {
          Get.offNamed(
            AppRoutes.home,
          );
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
    _cacheManager.saveLocaleIndex(index);
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

  Future<void> saveCurrentBrand(Brand brand) async {
    _cacheManager.saveCurrentBrand(brand);
  }

  bool emailIsValid() => GetUtils.isEmail(email.value);

  bool passwordIsValid() => password.value.length >= 8;
}
