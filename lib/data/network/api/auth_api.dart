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

  @POST('/experts/reset')
  Future<void> sendEmailForReset(
    @Body() ResetPasswordRequest request,
  );

  @GET('/experts/reset/{token}')
  Future<void> verifyResetToken({
    @Query('token') required String token,
  });

  @PUT('/experts/reset/{token}')
  Future<void> sendPasswordForReset({
    @Query('token') required String token,
    @Body() required ResetPasswordRequest request,
  });
}
