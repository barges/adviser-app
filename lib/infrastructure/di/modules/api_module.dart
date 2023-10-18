import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../data/cache/fortunica_caching_manager.dart';
import '../../../data/cache/secure_storage_manager.dart';
import '../../../fortunica_constants.dart';
import '../../../global.dart';
import '../dio_interceptors/app_interceptor.dart';

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
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);
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
    final secureStorageManager = globalGetIt.get<SecureStorageManager>();
    String? id = await secureStorageManager.getDeviceId();
    if (Platform.isAndroid) {
      const AndroidId androidIdPlugin = AndroidId();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (id == null) {
        id = await androidIdPlugin.getId();
        secureStorageManager.saveDeviceId(id!);
      }
      headers['x-adviqo-adid'] = id;
      headers['x-adviqo-device-name'] = androidInfo.model;
      headers['x-adviqo-device-version'] = androidInfo.version.release;
      headers['x-adviqo-is-physical-device'] = androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (id == null) {
        id = iosInfo.identifierForVendor;
        secureStorageManager.saveDeviceId(id!);
      }
      headers['x-adviqo-adid'] = id;
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
