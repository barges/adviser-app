import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/network/api/auth_api.dart';
import 'package:shared_advisor_interface/data/network/responses/login_response.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;

  AuthRepositoryImpl()
      : _api = Get.find<AuthApi>();

  @override
  Future<LoginResponse?> login() async {
    LoginResponse? response = await _api.login();
    return response;
  }
}
