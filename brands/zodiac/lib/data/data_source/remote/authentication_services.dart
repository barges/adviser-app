import 'package:shared_advisor_interface/infrastructure/architecture/data/base_error.dart';
import 'package:shared_advisor_interface/infrastructure/architecture/data/base_response.dart';
import 'package:injectable/injectable.dart';
import 'package:zodiac/zodiac.dart';

@injectable
class AuthenticationServices {
  Future<BaseResponse<String, BaseError>> sendAuth() async {
    await Future.delayed(const Duration(seconds: 3));
    return BaseResponse.completed("Called the Auth successfully");
  }
}
