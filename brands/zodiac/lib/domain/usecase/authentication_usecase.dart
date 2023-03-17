import 'package:zodiac/domain/repositories/authentication_repository.dart';
import 'package:injectable/injectable.dart';

import 'package:shared_advisor_interface/infrastructure/architecture/base_usecase.dart';
import 'package:shared_advisor_interface/infrastructure/architecture/data/base_error.dart';
import 'package:shared_advisor_interface/infrastructure/architecture/data/base_response.dart';

import 'package:zodiac/zodiac.dart';

@injectable
class AuthenticationUseCase extends BaseUseCase<AuthenticationRepository> {
  AuthenticationUseCase(AuthenticationRepository repository)
      : super(repository);

  Future<BaseResponse<String, BaseError>> sendAuth() async =>
      repository.sendAuth();
}
