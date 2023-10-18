import 'package:retrofit/dio.dart';

import '../../data/network/requests/reset_password_request.dart';
import '../../data/network/responses/login_response.dart';

abstract class FortunicaAuthRepository {
  Future<LoginResponse?> login();

  Future<HttpResponse> logout();

  Future<bool> sendEmailForReset(
    ResetPasswordRequest request,
  );

  Future<bool> sendPasswordForReset({
    required String token,
    required ResetPasswordRequest request,
  });

  Future<bool> verifyToken({
    required String token,
  });
}
