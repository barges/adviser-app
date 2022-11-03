import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/network/api/auth_api.dart';
import 'package:shared_advisor_interface/data/network/api/customer_api.dart';
import 'package:shared_advisor_interface/data/network/api/chats_api.dart';
import 'package:shared_advisor_interface/data/network/api/user_api.dart';
import 'package:shared_advisor_interface/data/repositories/auth_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/customer_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/chats_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/user_repository_impl.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/di/bindings/dio_interceptors/app_interceptor.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/services/fresh_chat_service.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager_impl.dart';

class InitBinding extends Bindings {
  final DeviceInfoPlugin deviceInfo =
      Get.put<DeviceInfoPlugin>(DeviceInfoPlugin());

  @override
  void dependencies() async {
    final CachingManager cacheManager = Get.find<CachingManager>();

    Dio dio = await _initDio(cacheManager);
    Get.put<Dio>(dio, permanent: true);

    ///APIs
    final AuthApi authApi = Get.put<AuthApi>(AuthApi(dio), permanent: true);
    final ChatsApi sessionsApi =
        Get.put<ChatsApi>(ChatsApi(dio), permanent: true);
    final UserApi userApi = Get.put<UserApi>(UserApi(dio), permanent: true);
    final CustomerApi customerApi =
        Get.put<CustomerApi>(CustomerApi(dio), permanent: true);

    ///Repositories
    Get.put<AuthRepository>(
        AuthRepositoryImpl(
          authApi,
        ),
        permanent: true);
    Get.put<ChatsRepository>(
        ChatsRepositoryImpl(
          sessionsApi,
        ),
        permanent: true);
    Get.put<UserRepository>(
        UserRepositoryImpl(
          userApi,
          cacheManager,
        ),
        permanent: true);
    Get.put<CustomerRepository>(
        CustomerRepositoryImpl(
          customerApi,
        ),
        permanent: true);

    ///Services
    Get.lazyPut<FreshChatService>(() => FreshChatServiceImpl());
    Get.lazyPut<PushNotificationManager>(() => PushNotificationManagerImpl());
  }

  Future<Dio> _initDio(CachingManager cacheManager) async {
    final dio = Dio();
    dio.options.baseUrl = AppConstants.baseUrl;
    dio.options.headers = await _getHeaders(cacheManager);
    dio.options.connectTimeout = 30000;
    dio.options.receiveTimeout = 30000;
    dio.options.sendTimeout = 30000;
    dio.interceptors.add(LogInterceptor(
        requestBody: true, responseBody: true, logPrint: simpleLogger.d));

    dio.interceptors.add(AppInterceptor());
    return dio;
  }

  Future<Map<String, dynamic>> _getHeaders(CachingManager cacheManager) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
      'x-adviqo-version': packageInfo.version,
      'x-adviqo-platform': Platform.operatingSystem,
      'Authorization': cacheManager
          .getTokenByBrand(cacheManager.getCurrentBrand() ?? Brand.fortunica),
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
