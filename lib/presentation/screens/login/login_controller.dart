import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

class LoginController extends GetxController {
  final AuthRepository _repository = Get.find<AuthRepository>();
  final CacheManager _cacheManager = Get.find<CacheManager>();

  final Rx<Brand> selectedBrand = Brand.fortunica.obs;

  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxBool hiddenPassword = true.obs;

  int index = 0;

  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
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

  Future<bool> login() async {
    Get.find<Dio>().options.headers['Authorization'] = _getAuthHeader();
    return await _repository.login();
  }

  String _getAuthHeader() {
    final bytes = utf8.encode(password.value);
    final hash = sha256.convert(bytes);
    return 'Basic ${base64.encode(utf8.encode('${email.value}:$hash'))}';
  }

  changeLocale(){
    Locale locale;
    if (index < S.delegate.supportedLocales.length - 1) {
      locale = S.delegate.supportedLocales[++index];
      Get.updateLocale(Locale(locale.languageCode,
          locale.languageCode.toUpperCase()));
    } else {
      index = 0;
      locale = S.delegate.supportedLocales[index];
      Get.updateLocale(Locale(locale.languageCode,
          locale.languageCode.toUpperCase()));
    }
    _cacheManager.saveLocaleIndex(index);
  }

  bool emailIsValid() => GetUtils.isEmail(email.value);

  bool passwordIsValid() => password.value.length >= 8;
}
