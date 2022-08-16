import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_advisor_interface/data/network/api/auth_api.dart';
import 'package:shared_advisor_interface/data/repositories/auth_repository_impl.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/main.dart';

class InitBinding extends Bindings {
  final DeviceInfoPlugin deviceInfo =
      Get.put<DeviceInfoPlugin>(DeviceInfoPlugin());

  @override
  void dependencies() async {
    await _initDio();
    Dio dio = Get.find<Dio>();

    ///APIs
    Get.lazyPut<AuthApi>(() => AuthApi(dio));

    ///Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl());
  }

  Future<void> _initDio() async {
    final dio = Dio();
    dio.options.baseUrl = 'https://api-staging.fortunica-app.com';
    dio.options.headers = await _getHeaders();
    dio.options.connectTimeout = 30000;
    dio.options.receiveTimeout = 30000;
    dio.options.sendTimeout = 30000;
    dio.interceptors.add(LogInterceptor(
        requestBody: true, responseBody: true, logPrint: logger.d));

    dio.interceptors.add(InterceptorsWrapper(
        onError: (dioError, handler) => _errorInterceptor(dioError)));
    Get.lazyPut<Dio>(() => dio);
  }

  _errorInterceptor(DioError dioError) async {
    // if (dioError.response?.statusCode == 401 ||
    //     dioError.response?.statusCode == 423) {
    //   // sl.get<CacheManager>().clear();
    //   // navigatorKey.currentState?.pushAndRemoveUntil(
    //   //     CupertinoPageRoute(
    //   //       builder: (_) => LoginScreen(),
    //   //     ),
    //   //     (settings) => false);
    // } else {
    return dioError;
    // }
  }

  Future<Map<String, dynamic>> _getHeaders() async {
    final PackageInfo packageInfo = await Get.putAsync<PackageInfo>(() => PackageInfo.fromPlatform());

    Map<String, dynamic> headers = {
      'Content-Type' : 'application/json',
      'x-adviqo-version' : packageInfo.version,
      'x-adviqo-platform' : Platform.operatingSystem,
    };

    // if (kDebugMode) {
    //   String baseUrl = await GetIt.I.get<CachingManager>().getBaseUrl();
    //
    //   if (baseUrl == null) {
    //     baseUrl = GetIt.I.get<Configuration>().setBaseUrl();
    //     GetIt.I.get<CachingManager>().setBaseUrl(baseUrl);
    //   } else {
    //     baseUrl = GetIt.I.get<Configuration>().setBaseUrl(newBaseUrl: baseUrl);
    //   }
    // }

    if (Platform.isAndroid) {
      const AndroidId androidIdPlugin = AndroidId();
      headers['x-adviqo-adid'] = await androidIdPlugin.getId();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      headers['x-adviqo-adid'] = iosInfo.identifierForVendor;
    }

    return headers;
  }


}
