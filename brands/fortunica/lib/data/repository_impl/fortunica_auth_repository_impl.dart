import 'package:injectable/injectable.dart';
import 'package:retrofit/dio.dart';

import 'package:fortunica/data/network/api/auth_api.dart';
import 'package:fortunica/data/network/requests/reset_password_request.dart';
import 'package:fortunica/data/network/responses/login_response.dart';
import 'package:fortunica/domain/repositories/fortunica_auth_repository.dart';

@Injectable(as: FortunicaAuthRepository)
class FortunicaAuthRepositoryImpl implements FortunicaAuthRepository {
  final AuthApi _api;

  FortunicaAuthRepositoryImpl(this._api);

  @override
  Future<LoginResponse?> login() async {
    return await _api.login();
  }

  @override
  Future<HttpResponse> logout() async {
    return await _api.logout();
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
