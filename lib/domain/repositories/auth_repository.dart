import 'package:shared_advisor_interface/data/network/responses/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse?> login();
}