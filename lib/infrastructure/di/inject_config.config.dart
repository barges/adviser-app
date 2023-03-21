// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i12;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/cache/global_caching_manager.dart' as _i9;
import '../../data/cache/global_caching_manager_impl.dart' as _i10;
import '../../data/data_source/remote/authentication_services.dart' as _i4;
import '../../data/data_source/remote/home_services.dart' as _i11;
import '../../data/repository_impl/authentication_repository_impl.dart' as _i17;
import '../../data/repository_impl/home_repository_impl.dart' as _i21;
import '../../domain/repositories/authentication_repository.dart' as _i16;
import '../../domain/repositories/home_screen_repository.dart' as _i20;
import '../../domain/usecase/authentication_usecase.dart' as _i18;
import '../../domain/usecase/home_screen_usecase.dart' as _i22;
import '../../main_cubit.dart' as _i13;
import '../../services/check_permission_service.dart' as _i19;
import '../../services/connectivity_service.dart' as _i6;
import '../../services/dynamic_link_service.dart' as _i7;
import '../../services/fresh_chat_service.dart' as _i8;
import '../../services/push_notification/push_notification_manager.dart'
    as _i14;
import '../../services/push_notification/push_notification_manager_impl.dart'
    as _i15;
import '../routing/app_router.dart' as _i3;
import 'brand_manager.dart' as _i5;
import 'inject_config.dart' as _i23; // ignore_for_file: unnecessary_lambdas

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
  gh.factory<_i4.AuthenticationServices>(() => _i4.AuthenticationServices());
  gh.factory<_i5.BrandManager>(() => registerModule.brandManager);
  gh.singleton<_i6.ConnectivityService>(_i6.ConnectivityService());
  gh.singleton<_i7.DynamicLinkService>(_i7.DynamicLinkService());
  gh.singleton<_i8.FreshChatService>(_i8.FreshChatServiceImpl());
  gh.factory<_i9.GlobalCachingManager>(() => _i10.GlobalCachingManagerImpl());
  gh.factory<_i11.HomeServices>(() => _i11.HomeServices());
  gh.factory<_i12.Key>(() => registerModule.key);
  gh.singleton<_i13.MainCubit>(_i13.MainCubit(
    get<_i9.GlobalCachingManager>(),
    get<_i6.ConnectivityService>(),
  ));
  gh.singleton<_i14.PushNotificationManager>(
      _i15.PushNotificationManagerImpl());
  gh.factory<_i16.AuthenticationRepository>(() =>
      _i17.AuthenticationRepositoryImpl(get<_i4.AuthenticationServices>()));
  gh.factory<_i18.AuthenticationUseCase>(
      () => _i18.AuthenticationUseCase(get<_i16.AuthenticationRepository>()));
  gh.singleton<_i19.CheckPermissionService>(
      _i19.CheckPermissionService(get<_i9.GlobalCachingManager>()));
  gh.factory<_i20.HomeScreenRepository>(
      () => _i21.HomeScreenRepositoryImpl(get<_i11.HomeServices>()));
  gh.factory<_i22.HomeScreenUseCase>(
      () => _i22.HomeScreenUseCase(get<_i20.HomeScreenRepository>()));
  return get;
}

class _$RegisterModule extends _i23.RegisterModule {
  @override
  _i12.UniqueKey get key => _i12.UniqueKey();
}
