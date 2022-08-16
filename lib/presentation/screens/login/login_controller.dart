import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/network/responses/login_response.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/main.dart';

class LoginController extends GetxController {

  final AuthRepository _repository = Get.find<AuthRepository>();

  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxBool hiddenPassword = true.obs;

  void login() async {
    Get.find<Dio>().options.headers['Authorization'] = _getAuthHeader();
    final LoginResponse? response = await _repository.login();
    logger.d(response?.accessToken);
  }

  String _getAuthHeader() {
    final bytes = utf8.encode(password.value);
    final hash = sha256.convert(bytes);
    return 'Basic ${base64.encode(utf8.encode('${email.value}:$hash'))}';
  }

  bool emailIsValid() => GetUtils.isEmail(email.value);

  bool passwordIsValid() => password.value.length >= 8;


}
