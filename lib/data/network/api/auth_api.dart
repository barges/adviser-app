import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_advisor_interface/data/network/requests/reset_password_request.dart';
import 'package:shared_advisor_interface/data/network/responses/login_response.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('/experts/login/app')
  Future<LoginResponse?> login();

  @POST('/reset/advisor')
  Future<void> resetPassword(@Body() ResetPasswordRequest request);
}
