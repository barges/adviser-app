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
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart'
    as _i3;
import 'package:shared_advisor_interface/main_cubit.dart' as _i11;
import 'package:shared_advisor_interface/services/connectivity_service.dart'
    as _i5;

import '../../data/cache/zodiac_caching_manager.dart' as _i12;
import '../../data/cache/zodiac_caching_manager_impl.dart' as _i13;
import '../../data/data_source/remote/authentication_services.dart' as _i4;
import '../../data/network/api/articles_api.dart' as _i26;
import '../../data/network/api/auth_api.dart' as _i27;
import '../../data/network/api/chats_api.dart' as _i28;
import '../../data/network/api/services_api.dart' as _i20;
import '../../data/network/api/user_api.dart' as _i21;
import '../../data/network/websocket_manager/websocket_manager.dart' as _i22;
import '../../data/network/websocket_manager/websocket_manager_impl.dart'
    as _i23;
import '../../data/repository_impl/zodiac_articles_repository_impl.dart'
    as _i30;
import '../../data/repository_impl/zodiac_auth_repository_impl.dart' as _i32;
import '../../data/repository_impl/zodiac_chats_repository_impl.dart' as _i34;
import '../../data/repository_impl/zodiac_user_repository_impl.dart' as _i25;
import '../../domain/repositories/zodiac_articles_repository.dart' as _i29;
import '../../domain/repositories/zodiac_auth_repository.dart' as _i31;
import '../../domain/repositories/zodiac_chats_repository.dart' as _i33;
import '../../domain/repositories/zodiac_user_repository.dart' as _i24;
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
  gh.singleton<_i11.MainCubit>(servicesModule.mainCubit);
  gh.factory<_i12.ZodiacCachingManager>(() => _i13.ZodiacCachingManagerImpl());
  gh.singleton<_i14.ZodiacMainCubit>(_i14.ZodiacMainCubit());
  gh.singleton<_i15.AppInterceptor>(_i15.AppInterceptor(
    get<_i11.MainCubit>(),
    get<_i14.ZodiacMainCubit>(),
    get<_i6.GlobalCachingManager>(),
  ));
  await gh.singletonAsync<_i19.Dio>(
    () => apiModule.initDio(
      get<_i6.GlobalCachingManager>(),
      get<_i15.AppInterceptor>(),
    ),
    preResolve: true,
  );
  gh.factory<_i20.ServicesApi>(() => _i20.ServicesApi(get<_i19.Dio>()));
  gh.factory<_i21.UserApi>(() => _i21.UserApi(get<_i19.Dio>()));
  gh.factory<_i22.WebSocketManager>(
      () => _i23.WebSocketManagerImpl(get<_i14.ZodiacMainCubit>()));
  gh.factory<_i24.ZodiacUserRepository>(
      () => _i25.ZodiacUserRepositoryImpl(get<_i21.UserApi>()));
  gh.factory<_i26.ArticlesApi>(() => _i26.ArticlesApi(get<_i19.Dio>()));
  gh.factory<_i27.AuthApi>(() => _i27.AuthApi(get<_i19.Dio>()));
  gh.factory<_i28.ChatsApi>(() => _i28.ChatsApi(get<_i19.Dio>()));
  gh.factory<_i29.ZodiacArticlesRepository>(
      () => _i30.ZodiacAuthRepositoryImpl(get<_i26.ArticlesApi>()));
  gh.factory<_i31.ZodiacAuthRepository>(
      () => _i32.ZodiacAuthRepositoryImpl(get<_i27.AuthApi>()));
  gh.factory<_i33.ZodiacChatsRepository>(
      () => _i34.ZodiacChatsRepositoryImpl(get<_i28.ChatsApi>()));
  return get;
}

class _$ServicesModule extends _i35.ServicesModule {}

class _$ApiModule extends _i36.ApiModule {}
