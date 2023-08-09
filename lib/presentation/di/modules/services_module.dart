import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/cache/data_caching_manager.dart';
import 'package:shared_advisor_interface/data/cache/secure_storage_manager.dart';
import 'package:shared_advisor_interface/data/cache/secure_storage_manager_impl.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/services/check_permission_service.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/dynamic_link_service.dart';
import 'package:shared_advisor_interface/presentation/services/fresh_chat_service.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager_impl.dart';

import 'module.dart';

class ServicesModule implements Module {
  @override
  Future<void> dependency() async {
    getIt.registerSingleton<CachingManager>(DataCachingManager());
    getIt.registerSingleton<SecureStorageManager>(SecureStorageManagerImpl());
    getIt.registerLazySingleton<FreshChatService>(() => FreshChatServiceImpl());
    getIt.registerLazySingleton<ConnectivityService>(
        () => ConnectivityService());
    getIt.registerLazySingleton<PushNotificationManager>(
        () => PushNotificationManagerImpl());
    getIt.registerSingleton<DynamicLinkService>(DynamicLinkService());
    getIt.registerSingleton<CheckPermissionService>(
        CheckPermissionService(getIt.get<CachingManager>()));
  }
}
