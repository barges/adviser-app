import 'package:shared_advisor_interface/infrastructure/architecture/base_repository.dart';

import 'package:shared_advisor_interface/infrastructure/architecture/data/base_error.dart';
import 'package:shared_advisor_interface/infrastructure/architecture/data/base_response.dart';

abstract class AuthenticationRepository extends BaseRepository {
  Future<BaseResponse<String, BaseError>> sendAuth();
}
