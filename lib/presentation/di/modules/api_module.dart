import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/network/api/auth_api.dart';
import 'package:shared_advisor_interface/data/network/api/chats_api.dart';
import 'package:shared_advisor_interface/data/network/api/customer_api.dart';
import 'package:shared_advisor_interface/data/network/api/user_api.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/di/dio_interceptors/app_interceptor.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

import 'module.dart';

class ApiModule implements Module {
  @override
  Future<void> dependency() async {
    getIt.registerSingleton(MainCubit(
      getIt.get<CachingManager>(),
      getIt.get<ConnectivityService>(),
    ));
    Dio dio = await _initDio(getIt.get<CachingManager>());
    getIt.registerLazySingleton<Dio>(() => dio);
    getIt.registerLazySingleton<AuthApi>(() => AuthApi(dio));
    getIt.registerLazySingleton<ChatsApi>(() => ChatsApi(dio));
    getIt.registerLazySingleton<UserApi>(() => UserApi(dio));
    getIt.registerLazySingleton<CustomerApi>(() => CustomerApi(dio));
  }

  Future<Dio> _initDio(CachingManager cacheManager) async {
    final dio = Dio();
    dio.options.baseUrl = AppConstants.baseUrlDev;
    dio.options.headers = await _getHeaders(cacheManager);
    dio.options.connectTimeout = 30000;
    dio.options.receiveTimeout = 30000;
    dio.options.sendTimeout = 30000;
    dio.interceptors.add(LogInterceptor(
        requestBody: true, responseBody: true, logPrint: simpleLogger.d));

    dio.interceptors.add(AppInterceptor(
      getIt.get<MainCubit>(),
      getIt.get<CachingManager>(),
    ));
    return dio;
  }

  Future<Map<String, dynamic>> _getHeaders(CachingManager cacheManager) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
      'x-adviqo-version': packageInfo.version,
      'x-adviqo-platform': Platform.operatingSystem,
      'Authorization': cacheManager
          .getTokenByBrand(cacheManager.getCurrentBrand() ?? Brand.fortunica),
    };
    if (Platform.isAndroid) {
      const AndroidId androidIdPlugin = AndroidId();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String? id = await androidIdPlugin.getId();
      headers['x-adviqo-adid'] = id;
      headers['x-advico-device-name'] = androidInfo.model;
      headers['x-advico-device-version'] = androidInfo.version.release;
      headers['x-advico-is-physical-device'] = androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      headers['x-adviqo-adid'] = iosInfo.identifierForVendor;
      headers['x-advico-device-name'] = iosInfo.name;
      headers['x-advico-device-version'] = iosInfo.systemVersion;
      headers['x-advico-is-physical-device'] = iosInfo.isPhysicalDevice;
    }

    return headers;
  }
}

extension DioHeadersExt on Dio {
  void addLocaleToHeader(Locale locale) {
    options.headers['x-adviqo-app-language'] = locale.languageCode;
  }

  void addAuthorizationToHeader(String token) {
    options.headers['Authorization'] = token;
  }
}
