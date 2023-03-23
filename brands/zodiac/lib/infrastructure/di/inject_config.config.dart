// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i12;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart'
    as _i6;
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart'
    as _i3;
import 'package:shared_advisor_interface/main_cubit.dart' as _i7;
import 'package:shared_advisor_interface/services/connectivity_service.dart'
    as _i5;

import '../../data/cache/zodiac_caching_manager.dart' as _i8;
import '../../data/cache/zodiac_caching_manager_impl.dart' as _i9;
import '../../data/data_source/remote/authentication_services.dart' as _i4;
import '../../data/network/api/articles_api.dart' as _i19;
import '../../data/network/api/auth_api.dart' as _i20;
import '../../data/network/api/chats_api.dart' as _i21;
import '../../data/network/api/services_api.dart' as _i13;
import '../../data/network/api/user_api.dart' as _i14;
import '../../data/network/websocket_manager/websocket_manager.dart' as _i15;
import '../../data/network/websocket_manager/websocket_manager_impl.dart'
    as _i16;
import '../../data/repository_impl/zodiac_articles_repository_impl.dart'
    as _i23;
import '../../data/repository_impl/zodiac_auth_repository_impl.dart' as _i25;
import '../../data/repository_impl/zodiac_chats_repository_impl.dart' as _i27;
import '../../data/repository_impl/zodiac_user_repository_impl.dart' as _i18;
import '../../domain/repositories/zodiac_articles_repository.dart' as _i22;
import '../../domain/repositories/zodiac_auth_repository.dart' as _i24;
import '../../domain/repositories/zodiac_chats_repository.dart' as _i26;
import '../../domain/repositories/zodiac_user_repository.dart' as _i17;
import '../../presentation/screens/home/home_cubit.dart' as _i29;
import '../../presentation/screens/home/tabs/articles/articles_cubit.dart'
    as _i28;
import '../../zodiac_main_cubit.dart' as _i10;
import 'dio_interceptors/app_interceptor.dart' as _i11;
import 'modules/api_module.dart' as _i31;
import 'modules/services_module.dart'
    as _i30; // ignore_for_file: unnecessary_lambdas

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
  gh.singleton<_i7.MainCubit>(servicesModule.mainCubit);
  gh.factory<_i8.ZodiacCachingManager>(() => _i9.ZodiacCachingManagerImpl());
  gh.singleton<_i10.ZodiacMainCubit>(_i10.ZodiacMainCubit());
  gh.singleton<_i11.AppInterceptor>(_i11.AppInterceptor(
    get<_i7.MainCubit>(),
    get<_i10.ZodiacMainCubit>(),
    get<_i6.GlobalCachingManager>(),
  ));
  await gh.singletonAsync<_i12.Dio>(
    () => apiModule.initDio(
      get<_i6.GlobalCachingManager>(),
      get<_i11.AppInterceptor>(),
    ),
    preResolve: true,
  );
  gh.factory<_i13.ServicesApi>(() => _i13.ServicesApi(get<_i12.Dio>()));
  gh.factory<_i14.UserApi>(() => _i14.UserApi(get<_i12.Dio>()));
  gh.factory<_i15.WebSocketManager>(
      () => _i16.WebSocketManagerImpl(get<_i10.ZodiacMainCubit>()));
  gh.factory<_i17.ZodiacUserRepository>(
      () => _i18.ZodiacUserRepositoryImpl(get<_i14.UserApi>()));
  gh.factory<_i19.ArticlesApi>(() => _i19.ArticlesApi(get<_i12.Dio>()));
  gh.factory<_i20.AuthApi>(() => _i20.AuthApi(get<_i12.Dio>()));
  gh.factory<_i21.ChatsApi>(() => _i21.ChatsApi(get<_i12.Dio>()));
  gh.factory<_i22.ZodiacArticlesRepository>(
      () => _i23.ZodiacAuthRepositoryImpl(get<_i19.ArticlesApi>()));
  gh.factory<_i24.ZodiacAuthRepository>(
      () => _i25.ZodiacAuthRepositoryImpl(get<_i20.AuthApi>()));
  gh.factory<_i26.ZodiacChatsRepository>(
      () => _i27.ZodiacChatsRepositoryImpl(get<_i21.ChatsApi>()));
  gh.lazySingleton<_i28.ArticlesCubit>(
      () => _i28.ArticlesCubit(get<_i22.ZodiacArticlesRepository>()));
  gh.lazySingleton<_i29.HomeCubit>(() => _i29.HomeCubit(
        get<_i8.ZodiacCachingManager>(),
        get<_i15.WebSocketManager>(),
        get<_i22.ZodiacArticlesRepository>(),
      ));
  return get;
}

class _$ServicesModule extends _i30.ServicesModule {}

class _$ApiModule extends _i31.ApiModule {}
