import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/forgot_password_request.dart';
import 'package:zodiac/data/network/requests/login_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse?> login({required LoginRequest request});

  Future<BaseResponse?> logout({required AuthorizedRequest request});

  Future<BaseResponse?> forgotPassword(
      {required ForgotPasswordRequest request});
}
