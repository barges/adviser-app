import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/fortunica_constants.dart';
import 'package:fortunica/infrastructure/di/dio_interceptors/app_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_advisor_interface/global.dart';

@module
abstract class ApiModule {
  @singleton
  @preResolve
  Future<Dio> initDio(
    FortunicaCachingManager cacheManager,
    AppInterceptor appInterceptor,
  ) async {
    final dio = Dio();
    dio.options.baseUrl = FortunicaConstants.baseUrl;
    dio.options.headers = await _getHeaders(cacheManager);
    dio.options.connectTimeout = 30000;
    dio.options.receiveTimeout = 30000;
    dio.options.sendTimeout = 30000;
    dio.interceptors.add(LogInterceptor(
        requestBody: true, responseBody: true, logPrint: simpleLogger.d));

    dio.interceptors.add(appInterceptor);
    return dio;
  }

  Future<Map<String, dynamic>> _getHeaders(
      FortunicaCachingManager cacheManager) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
      'x-adviqo-version': packageInfo.version,
      'x-adviqo-platform': Platform.operatingSystem,
      'x-adviqo-app-id': packageInfo.packageName,
      'Authorization': cacheManager.getUserToken(),
    };
    if (Platform.isAndroid) {
      const AndroidId androidIdPlugin = AndroidId();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String? id = await androidIdPlugin.getId();
      headers['x-adviqo-adid'] = id;
      headers['x-adviqo-device-name'] = androidInfo.model;
      headers['x-adviqo-device-version'] = androidInfo.version.release;
      headers['x-adviqo-is-physical-device'] = androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      headers['x-adviqo-adid'] = iosInfo.identifierForVendor;
      headers['x-adviqo-device-name'] = iosInfo.name;
      headers['x-adviqo-device-version'] = iosInfo.systemVersion;
      headers['x-adviqo-is-physical-device'] = iosInfo.isPhysicalDevice;
    }

    return headers;
  }
}

extension DioHeadersExt on Dio {
  void addLocaleToHeader(String languageCode) {
    options.headers['x-adviqo-app-language'] = languageCode;
  }

  void addAuthorizationToHeader(String token) {
    options.headers['Authorization'] = token;
  }
}
