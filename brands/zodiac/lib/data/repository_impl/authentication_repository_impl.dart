import 'package:zodiac/data/data_source/remote/authentication_services.dart';
import 'package:zodiac/domain/repositories/authentication_repository.dart';
import 'package:injectable/injectable.dart';

import 'package:shared_advisor_interface/infrastructure/architecture/data/base_error.dart';
import 'package:shared_advisor_interface/infrastructure/architecture/data/base_response.dart';
import 'package:zodiac/zodiac.dart';

@Injectable(as: AuthenticationRepository)
class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AuthenticationServices authenticationServices;

  AuthenticationRepositoryImpl(this.authenticationServices);

  @override
  Future<BaseResponse<String, BaseError>> sendAuth() => authenticationServices.sendAuth();
}
