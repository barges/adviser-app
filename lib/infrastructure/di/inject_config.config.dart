// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i10;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/cache/global_caching_manager.dart' as _i8;
import '../../data/cache/global_caching_manager_impl.dart' as _i9;
import '../../main_cubit.dart' as _i11;
import '../../services/check_permission_service.dart' as _i14;
import '../../services/connectivity_service.dart' as _i5;
import '../../services/dynamic_link_service.dart' as _i6;
import '../../services/fresh_chat_service.dart' as _i7;
import '../../services/push_notification/push_notification_manager.dart'
    as _i12;
import '../../services/push_notification/push_notification_manager_impl.dart'
    as _i13;
import '../routing/app_router.dart' as _i3;
import 'brand_manager.dart' as _i4;
import 'inject_config.dart' as _i15; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.singleton<_i3.AppRouter>(registerModule.navigationService);
  gh.factory<_i4.BrandManager>(() => registerModule.brandManager);
  gh.singleton<_i5.ConnectivityService>(_i5.ConnectivityService());
  gh.singleton<_i6.DynamicLinkService>(_i6.DynamicLinkService());
  gh.singleton<_i7.FreshChatService>(_i7.FreshChatServiceImpl());
  gh.factory<_i8.GlobalCachingManager>(() => _i9.GlobalCachingManagerImpl());
  gh.factory<_i10.Key>(() => registerModule.key);
  gh.singleton<_i11.MainCubit>(_i11.MainCubit(
    get<_i8.GlobalCachingManager>(),
    get<_i5.ConnectivityService>(),
  ));
  gh.singleton<_i12.PushNotificationManager>(
      _i13.PushNotificationManagerImpl());
  gh.singleton<_i14.CheckPermissionService>(
      _i14.CheckPermissionService(get<_i8.GlobalCachingManager>()));
  return get;
}

class _$RegisterModule extends _i15.RegisterModule {
  @override
  _i10.UniqueKey get key => _i10.UniqueKey();
}
