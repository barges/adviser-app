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
import '../../data/network/api/articles_api.dart' as _i26;
import '../../data/network/api/auth_api.dart' as _i29;
import '../../data/network/api/chats_api.dart' as _i32;
import '../../data/network/api/services_api.dart' as _i20;
import '../../data/network/api/user_api.dart' as _i21;
import '../../data/network/websocket_manager/websocket_manager.dart' as _i24;
import '../../data/network/websocket_manager/websocket_manager_impl.dart'
    as _i25;
import '../../data/repository_impl/articles_repository_impl.dart' as _i28;
import '../../data/repository_impl/auth_repository_impl.dart' as _i31;
import '../../data/repository_impl/authentication_repository_impl.dart' as _i17;
import '../../data/repository_impl/chats_repository_impl.dart' as _i34;
import '../../data/repository_impl/home_repository_impl.dart' as _i8;
import '../../data/repository_impl/user_repository_impl.dart' as _i23;
import '../../domain/repositories/articles_repository.dart' as _i27;
import '../../domain/repositories/auth_repository.dart' as _i30;
import '../../domain/repositories/authentication_repository.dart' as _i16;
import '../../domain/repositories/chats_repository.dart' as _i33;
import '../../domain/repositories/home_screen_repository.dart' as _i7;
import '../../domain/repositories/user_repository.dart' as _i22;
import '../../domain/usecase/authentication_usecase.dart' as _i18;
import '../../domain/usecase/home_screen_usecase.dart' as _i10;
import '../../zodiac_main_cubit.dart' as _i14;
import 'dio_interceptors/app_interceptor.dart' as _i15;
import 'modules/api_module.dart' as _i36;
import 'modules/services_module.dart'
    as _i35; // ignore_for_file: unnecessary_lambdas

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
  gh.factory<_i20.ServicesApi>(() => _i20.ServicesApi(get<_i19.Dio>()));
  gh.factory<_i21.UserApi>(() => _i21.UserApi(get<_i19.Dio>()));
  gh.factory<_i22.UserRepository>(
      () => _i23.UserRepositoryImpl(get<_i21.UserApi>()));
  gh.factory<_i24.WebSocketManager>(
      () => _i25.WebSocketManagerImpl(get<_i14.ZodiacMainCubit>()));
  gh.factory<_i26.ArticlesApi>(() => _i26.ArticlesApi(get<_i19.Dio>()));
  gh.factory<_i27.ArticlesRepository>(
      () => _i28.AuthRepositoryImpl(get<_i26.ArticlesApi>()));
  gh.factory<_i29.AuthApi>(() => _i29.AuthApi(get<_i19.Dio>()));
  gh.factory<_i30.AuthRepository>(
      () => _i31.AuthRepositoryImpl(get<_i29.AuthApi>()));
  gh.factory<_i32.ChatsApi>(() => _i32.ChatsApi(get<_i19.Dio>()));
  gh.factory<_i33.ChatsRepository>(
      () => _i34.ChatsRepositoryImpl(get<_i32.ChatsApi>()));
  return get;
}

class _$ServicesModule extends _i35.ServicesModule {}

class _$ApiModule extends _i36.ApiModule {}
