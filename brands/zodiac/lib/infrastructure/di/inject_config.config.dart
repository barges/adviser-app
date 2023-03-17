// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i19;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart'
    as _i6;
import 'package:shared_advisor_interface/data/data_source/remote/home_services.dart'
    as _i9;
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart'
    as _i3;
import 'package:shared_advisor_interface/main_cubit.dart' as _i11;
import 'package:shared_advisor_interface/services/connectivity_service.dart'
    as _i5;

import '../../data/cache/zodiac_caching_manager.dart' as _i12;
import '../../data/cache/zodiac_caching_manager_impl.dart' as _i13;
import '../../data/data_source/remote/authentication_services.dart' as _i4;
import '../../data/network/api/auth_api.dart' as _i20;
import '../../data/repository_impl/auth_repository_impl.dart' as _i22;
import '../../data/repository_impl/authentication_repository_impl.dart' as _i17;
import '../../data/repository_impl/home_repository_impl.dart' as _i8;
import '../../domain/repositories/auth_repository.dart' as _i21;
import '../../domain/repositories/authentication_repository.dart' as _i16;
import '../../domain/repositories/home_screen_repository.dart' as _i7;
import '../../domain/usecase/authentication_usecase.dart' as _i18;
import '../../domain/usecase/home_screen_usecase.dart' as _i10;
import '../../zodiac_main_cubit.dart' as _i14;
import 'dio_interceptors/app_interceptor.dart' as _i15;
import 'modules/api_module.dart' as _i24;
import 'modules/services_module.dart'
    as _i23; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final servicesModule = _$ServicesModule();
  final apiModule = _$ApiModule();
  gh.singleton<_i3.AppRouter>(servicesModule.navigationService);
  gh.factory<_i4.AuthenticationServices>(() => _i4.AuthenticationServices());
  gh.singleton<_i5.ConnectivityService>(servicesModule.connectivityService);
  gh.singleton<_i6.GlobalCachingManager>(servicesModule.globalCachingManager);
  gh.factory<_i7.HomeScreenRepository>(
      () => _i8.HomeScreenRepositoryImpl(get<_i9.HomeServices>()));
  gh.factory<_i10.HomeScreenUseCase>(
      () => _i10.HomeScreenUseCase(get<_i7.HomeScreenRepository>()));
  gh.singleton<_i11.MainCubit>(servicesModule.mainCubit);
  gh.factory<_i12.ZodiacCachingManager>(() => _i13.ZodiacCachingManagerImpl());
  gh.singleton<_i14.ZodiacMainCubit>(_i14.ZodiacMainCubit(
    get<_i6.GlobalCachingManager>(),
    get<_i5.ConnectivityService>(),
  ));
  gh.singleton<_i15.AppInterceptor>(_i15.AppInterceptor(
    get<_i11.MainCubit>(),
    get<_i14.ZodiacMainCubit>(),
    get<_i6.GlobalCachingManager>(),
  ));
  gh.factory<_i16.AuthenticationRepository>(() =>
      _i17.AuthenticationRepositoryImpl(get<_i4.AuthenticationServices>()));
  gh.factory<_i18.AuthenticationUseCase>(
      () => _i18.AuthenticationUseCase(get<_i16.AuthenticationRepository>()));
  await gh.singletonAsync<_i19.Dio>(
    () => apiModule.initDio(
      get<_i6.GlobalCachingManager>(),
      get<_i15.AppInterceptor>(),
    ),
    preResolve: true,
  );
  gh.factory<_i20.AuthApi>(() => _i20.AuthApi(get<_i19.Dio>()));
  gh.factory<_i21.AuthRepository>(
      () => _i22.AuthRepositoryImpl(get<_i20.AuthApi>()));
  return get;
}

class _$ServicesModule extends _i23.ServicesModule {}

class _$ApiModule extends _i24.ApiModule {}
