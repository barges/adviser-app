import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/check_permission_service.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:shared_advisor_interface/services/fresh_chat_service.dart';
import 'package:shared_advisor_interface/services/push_notification/push_notification_manager.dart';
import 'package:shared_advisor_interface/services/silent_mode_service.dart';

@module
abstract class ServicesModule {
  @singleton
  BrandManager get brandManager => globalGetIt.get<BrandManager>();

  @singleton
  MainCubit get mainCubit => globalGetIt.get<MainCubit>();

  @singleton
  GlobalCachingManager get globalCachingManager =>
      globalGetIt.get<GlobalCachingManager>();

  @singleton
  ConnectivityService get connectivityService =>
      globalGetIt.get<ConnectivityService>();

  @singleton
  FreshChatService get freshChatService => globalGetIt.get<FreshChatService>();

  @singleton
  PushNotificationManager get pushNotificationManager =>
      globalGetIt.get<PushNotificationManager>();

  @singleton
  CheckPermissionService get checkPermissionService =>
      globalGetIt.get<CheckPermissionService>();

  @singleton
  SilentModeService get silentModeService =>
      globalGetIt.get<SilentModeService>();
}
