import 'package:shared_advisor_interface/data/network/requests/reset_password_request.dart';
import 'package:shared_advisor_interface/data/network/responses/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse?> login();

  Future<bool> resetPassword(ResetPasswordRequest request);
}
