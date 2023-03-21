import 'package:injectable/injectable.dart';
import 'package:zodiac/data/network/api/auth_api.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/forgot_password_request.dart';
import 'package:zodiac/data/network/requests/login_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/login_response.dart';
import 'package:zodiac/domain/repositories/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;

  AuthRepositoryImpl(this._api);

  @override
  Future<LoginResponse?> login({required LoginRequest request}) async {
    return await _api.login(request: request);
  }

  @override
  Future<BaseResponse?> logout({required AuthorizedRequest request}) async {
    return await _api.logout(request: request);
  }

  @override
  Future<BaseResponse?> forgotPassword(
      {required ForgotPasswordRequest request}) async {
    return await _api.forgotPassword(request: request);
  }
}
