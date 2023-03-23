import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/check_permission_service.dart';
import 'package:shared_advisor_interface/services/dynamic_link_service.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:shared_advisor_interface/services/fresh_chat_service.dart';
import 'package:shared_advisor_interface/services/push_notification/push_notification_manager.dart';
import 'package:injectable/injectable.dart';

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
  AppRouter get navigationService => globalGetIt.get<AppRouter>();

  @singleton
  ConnectivityService get connectivityService =>
      globalGetIt.get<ConnectivityService>();

  @singleton
  CheckPermissionService get checkPermissionService =>
      globalGetIt.get<CheckPermissionService>();

  @singleton
  FreshChatService get freshChatService => globalGetIt.get<FreshChatService>();

  @singleton
  PushNotificationManager get pushNotificationManager =>
      globalGetIt.get<PushNotificationManager>();

  @singleton
  DynamicLinkService get dynamicLinkService =>
      globalGetIt.get<DynamicLinkService>();
}
