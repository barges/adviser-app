import 'package:retrofit/dio.dart';
import 'package:shared_advisor_interface/data/network/requests/reset_password_request.dart';
import 'package:shared_advisor_interface/data/network/responses/login_response.dart';

abstract class AuthRepository {
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
