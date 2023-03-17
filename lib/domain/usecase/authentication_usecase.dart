import 'package:shared_advisor_interface/domain/repositories/authentication_repository.dart';
import 'package:injectable/injectable.dart';

import 'package:shared_advisor_interface/infrastructure/architecture/base_usecase.dart';

@injectable
class AuthenticationUseCase extends BaseUseCase<AuthenticationRepository> {
  AuthenticationUseCase(AuthenticationRepository repository)
      : super(repository);
}
