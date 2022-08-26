import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/network/requests/reset_password_request.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/presentation/runnable_screen/runnable_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_controller.dart';

class ForgotPasswordController extends RunnableController {
  final AuthRepository _repository;
  final CacheManager _cacheManager;

  final Brand? currentBrand;

  ForgotPasswordController(this._repository, this._cacheManager)
      : currentBrand = _cacheManager.getCurrentBrand();

  final RxString errorMessage = ''.obs;

  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxString confirmPassword = ''.obs;
  final RxBool hiddenPassword = true.obs;
  final RxBool hiddenConfirmPassword = true.obs;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    ever(email, (_) => clearErrorMessage());
    ever(password, (_) => clearErrorMessage());
    ever(confirmPassword, (_) => clearErrorMessage());
    emailController.addListener(() {
      email.value = emailController.text;
    });
    passwordController.addListener(() {
      password.value = passwordController.text;
    });
    confirmPasswordController.addListener(() {
      confirmPassword.value = confirmPasswordController.text;
    });
  }

  Future<void> resetPassword(BuildContext context) async {
    if (emailIsValid() &&
        passwordIsValid() &&
        password.value == confirmPassword.value) {
      try {
        final bool success = await run(_repository.resetPassword(
            ResetPasswordRequest(
                email: email.value, password: confirmPassword.value.to256)));
        if (success) {
          Get.find<LoginController>()
              .setSuccessMessage(context, showEmailButton: true);
          Get.back();
        }
      } on DioError catch (e) {
        errorMessage.value = e.response?.data['status'] ?? '';
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void clearErrorMessage() {
    if (errorMessage.value.isNotEmpty) {
      errorMessage.value = '';
    }
  }

  bool emailIsValid() => GetUtils.isEmail(email.value);

  bool passwordIsValid() => password.value.length >= 8;

  bool confirmPasswordIsValid() => password.value.length >= 8;
}
