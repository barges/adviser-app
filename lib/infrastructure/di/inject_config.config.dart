// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/cache/global_caching_manager.dart' as _i6;
import '../../data/cache/global_caching_manager_impl.dart' as _i7;
import '../../main_cubit.dart' as _i12;
import '../../services/check_permission_service.dart' as _i11;
import '../../services/connectivity_service.dart' as _i3;
import '../../services/dynamic_link_service.dart' as _i4;
import '../../services/fresh_chat_service.dart' as _i5;
import '../../services/push_notification/push_notification_manager.dart' as _i8;
import '../../services/push_notification/push_notification_manager_impl.dart'
    as _i9;
import 'brand_manager.dart' as _i10; // ignore_for_file: unnecessary_lambdas

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
  gh.singleton<_i3.ConnectivityService>(_i3.ConnectivityService());
  gh.singleton<_i4.DynamicLinkService>(_i4.DynamicLinkService());
  gh.singleton<_i5.FreshChatService>(_i5.FreshChatServiceImpl());
  gh.factory<_i6.GlobalCachingManager>(() => _i7.GlobalCachingManagerImpl());
  gh.singleton<_i8.PushNotificationManager>(_i9.PushNotificationManagerImpl());
  gh.singleton<_i10.BrandManager>(
      _i10.BrandManager(get<_i6.GlobalCachingManager>()));
  gh.singleton<_i11.CheckPermissionService>(
      _i11.CheckPermissionService(get<_i6.GlobalCachingManager>()));
  gh.singleton<_i12.MainCubit>(_i12.MainCubit(
    get<_i6.GlobalCachingManager>(),
    get<_i10.BrandManager>(),
    get<_i3.ConnectivityService>(),
  ));
  return get;
}
