import 'package:shared_advisor_interface/data/network/requests/reset_password_request.dart';

abstract class AuthRepository {
  Future<bool> login();

  Future<bool> resetPassword(ResetPasswordRequest request);
}
