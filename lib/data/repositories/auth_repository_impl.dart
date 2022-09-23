import 'package:shared_advisor_interface/data/network/api/auth_api.dart';
import 'package:shared_advisor_interface/data/network/requests/reset_password_request.dart';
import 'package:shared_advisor_interface/data/network/responses/login_response.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;

  AuthRepositoryImpl(this._api);

  @override
  Future<LoginResponse?> login() async {
    return await _api.login();
  }

  @override
  Future<bool> resetPassword(ResetPasswordRequest request) async {
    await _api.resetPassword(request);
    return true;
  }
}
