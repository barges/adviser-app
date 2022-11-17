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
  Future<bool> sendEmailForReset(ResetPasswordRequest request) async {
    await _api.sendEmailForReset(request);
    return true;
  }

  @override
  Future<bool> sendPasswordForReset({
    required String token,
    required ResetPasswordRequest request,
  }) async {
    await _api.sendPasswordForReset(
      request: request,
      token: token,
    );
    return true;
  }

  @override
  Future<bool> verifyToken({
    required String token,
  }) async {
    await _api.verifyResetToken(
      token: token,
    );
    return true;
  }
}
