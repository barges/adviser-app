import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/forgot_password_request.dart';
import 'package:zodiac/data/network/requests/login_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/login_response.dart';

part 'auth_api.g.dart';

@RestApi()
@injectable
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('/login')
  Future<LoginResponse?> login({@Body() required LoginRequest request});

  @POST('/logout')
  Future<BaseResponse?> logout({@Body() required AuthorizedRequest request});

  @POST('/forgot-password')
  Future<LoginResponse?> forgotPassword(
      {@Body() required ForgotPasswordRequest request});
}
