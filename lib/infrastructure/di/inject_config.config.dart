// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i11;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/cache/global_caching_manager.dart' as _i8;
import '../../data/cache/global_caching_manager_impl.dart' as _i9;
import '../../data/data_source/remote/authentication_services.dart' as _i4;
import '../../data/data_source/remote/home_services.dart' as _i10;
import '../../data/repository_impl/authentication_repository_impl.dart' as _i14;
import '../../data/repository_impl/home_repository_impl.dart' as _i18;
import '../../domain/repositories/authentication_repository.dart' as _i13;
import '../../domain/repositories/home_screen_repository.dart' as _i17;
import '../../domain/usecase/authentication_usecase.dart' as _i15;
import '../../domain/usecase/home_screen_usecase.dart' as _i19;
import '../../main_cubit.dart' as _i12;
import '../../services/check_permission_service.dart' as _i16;
import '../../services/connectivity_service.dart' as _i6;
import '../../services/fresh_chat_service.dart' as _i7;
import '../routing/app_router.dart' as _i3;
import 'brand_manager.dart' as _i5;
import 'inject_config.dart' as _i20; // ignore_for_file: unnecessary_lambdas

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
  gh.singleton<_i7.FreshChatService>(_i7.FreshChatServiceImpl());
  gh.factory<_i8.GlobalCachingManager>(() => _i9.GlobalCachingManagerImpl());
  gh.factory<_i10.HomeServices>(() => _i10.HomeServices());
  gh.factory<_i11.Key>(() => registerModule.key);
  gh.singleton<_i12.MainCubit>(_i12.MainCubit(
    get<_i3.AppRouter>(),
    get<_i8.GlobalCachingManager>(),
    get<_i6.ConnectivityService>(),
  ));
  gh.factory<_i13.AuthenticationRepository>(() =>
      _i14.AuthenticationRepositoryImpl(get<_i4.AuthenticationServices>()));
  gh.factory<_i15.AuthenticationUseCase>(
      () => _i15.AuthenticationUseCase(get<_i13.AuthenticationRepository>()));
  gh.singleton<_i16.CheckPermissionService>(
      _i16.CheckPermissionService(get<_i8.GlobalCachingManager>()));
  gh.factory<_i17.HomeScreenRepository>(
      () => _i18.HomeScreenRepositoryImpl(get<_i10.HomeServices>()));
  gh.factory<_i19.HomeScreenUseCase>(
      () => _i19.HomeScreenUseCase(get<_i17.HomeScreenRepository>()));
  return get;
}

class _$RegisterModule extends _i20.RegisterModule {
  @override
  _i11.UniqueKey get key => _i11.UniqueKey();
}
