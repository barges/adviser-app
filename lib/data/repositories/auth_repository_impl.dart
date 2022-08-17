import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/network/api/auth_api.dart';
import 'package:shared_advisor_interface/data/network/responses/login_response.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;
  final CacheManager _cacheManager;

  AuthRepositoryImpl()
      : _api = Get.find<AuthApi>(),
        _cacheManager = Get.find<CacheManager>();

  @override
  Future<bool> login() async {
    LoginResponse? response = await _api.login();
    String? token = response?.accessToken;
    if (token != null && token.isNotEmpty) {
      String jvtToken = 'JWT $token';
      await _cacheManager.saveToken('JWT $token');
      Get.find<Dio>().options.headers['Authorization'] = jvtToken;
    }

    return _cacheManager.isLoggedIn() ?? false;
  }
}
