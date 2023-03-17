

import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/check_permission_service.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:shared_advisor_interface/services/fresh_chat_service.dart';
import 'package:shared_advisor_interface/services/push_notification/push_notification_manager.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ServicesModule {

  @singleton
  MainCubit get mainCubit =>
      globalGetIt.get<MainCubit>();

  @singleton
  GlobalCachingManager get globalCachingManager =>
      globalGetIt.get<GlobalCachingManager>();

  @singleton
  AppRouter get navigationService =>
      globalGetIt.get<AppRouter>();

  @singleton
  ConnectivityService get connectivityService =>
      globalGetIt.get<ConnectivityService>();

  @singleton
  CheckPermissionService get checkPermissionService =>
      globalGetIt.get<CheckPermissionService>();

  @singleton
  FreshChatService get freshChatService =>
      globalGetIt.get<FreshChatService>();

}
