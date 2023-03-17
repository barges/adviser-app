import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fortunica/data/network/requests/reset_password_request.dart';
import 'package:fortunica/data/network/responses/login_response.dart';

part 'auth_api.g.dart';


@RestApi()
@injectable
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('/experts/login/app')
  Future<LoginResponse?> login();

  @POST('/experts/logout')
  Future<HttpResponse> logout();

  @POST('/experts/reset')
  Future<void> sendEmailForReset(
    @Body() ResetPasswordRequest request,
  );

  @GET('/experts/reset/{token}')
  Future<void> verifyResetToken({
    @Path('token') required String token,
  });

  @PUT('/experts/reset/{token}')
  Future<void> sendPasswordForReset({
    @Path('token') required String token,
    @Body() required ResetPasswordRequest request,
  });
}
