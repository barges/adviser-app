// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i16;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart'
    as _i7;
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart'
    as _i3;
import 'package:shared_advisor_interface/main_cubit.dart' as _i8;
import 'package:shared_advisor_interface/services/check_permission_service.dart'
    as _i4;
import 'package:shared_advisor_interface/services/connectivity_service.dart'
    as _i5;
import 'package:shared_advisor_interface/services/fresh_chat_service.dart'
    as _i6;
import 'package:shared_advisor_interface/services/push_notification/push_notification_manager.dart'
    as _i9;

import '../../data/cache/zodiac_caching_manager.dart' as _i10;
import '../../data/cache/zodiac_caching_manager_impl.dart' as _i11;
import '../../data/network/api/articles_api.dart' as _i21;
import '../../data/network/api/auth_api.dart' as _i22;
import '../../data/network/api/chats_api.dart' as _i23;
import '../../data/network/api/services_api.dart' as _i17;
import '../../data/network/api/user_api.dart' as _i18;
import '../../data/repository_impl/zodiac_articles_repository_impl.dart'
    as _i25;
import '../../data/repository_impl/zodiac_auth_repository_impl.dart' as _i27;
import '../../data/repository_impl/zodiac_chats_repository_impl.dart' as _i29;
import '../../data/repository_impl/zodiac_user_repository_impl.dart' as _i20;
import '../../domain/repositories/zodiac_articles_repository.dart' as _i24;
import '../../domain/repositories/zodiac_auth_repository.dart' as _i26;
import '../../domain/repositories/zodiac_chats_repository.dart' as _i28;
import '../../domain/repositories/zodiac_user_repository.dart' as _i19;
import '../../services/websocket_manager/websocket_manager.dart' as _i13;
import '../../services/websocket_manager/websocket_manager_impl.dart' as _i14;
import '../../zodiac_main_cubit.dart' as _i12;
import 'dio_interceptors/app_interceptor.dart' as _i15;
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
  gh.singleton<_i3.BrandManager>(servicesModule.brandManager);
  gh.singleton<_i4.CheckPermissionService>(
      servicesModule.checkPermissionService);
  gh.singleton<_i5.ConnectivityService>(servicesModule.connectivityService);
  gh.singleton<_i6.FreshChatService>(servicesModule.freshChatService);
  gh.singleton<_i7.GlobalCachingManager>(servicesModule.globalCachingManager);
  gh.singleton<_i8.MainCubit>(servicesModule.mainCubit);
  gh.singleton<_i9.PushNotificationManager>(
      servicesModule.pushNotificationManager);
  gh.factory<_i10.ZodiacCachingManager>(() => _i11.ZodiacCachingManagerImpl());
  gh.singleton<_i12.ZodiacMainCubit>(_i12.ZodiacMainCubit());
  gh.singleton<_i13.WebSocketManager>(_i14.WebSocketManagerImpl(
    get<_i12.ZodiacMainCubit>(),
    get<_i10.ZodiacCachingManager>(),
  ));
  gh.singleton<_i15.AppInterceptor>(_i15.AppInterceptor(
    get<_i8.MainCubit>(),
    get<_i12.ZodiacMainCubit>(),
    get<_i10.ZodiacCachingManager>(),
    get<_i13.WebSocketManager>(),
  ));
  await gh.singletonAsync<_i16.Dio>(
    () => apiModule.initDio(
      get<_i7.GlobalCachingManager>(),
      get<_i15.AppInterceptor>(),
    ),
    preResolve: true,
  );
  gh.factory<_i17.ServicesApi>(() => _i17.ServicesApi(get<_i16.Dio>()));
  gh.factory<_i18.UserApi>(() => _i18.UserApi(get<_i16.Dio>()));
  gh.factory<_i19.ZodiacUserRepository>(
      () => _i20.ZodiacUserRepositoryImpl(get<_i18.UserApi>()));
  gh.factory<_i21.ArticlesApi>(() => _i21.ArticlesApi(get<_i16.Dio>()));
  gh.factory<_i22.AuthApi>(() => _i22.AuthApi(get<_i16.Dio>()));
  gh.factory<_i23.ChatsApi>(() => _i23.ChatsApi(get<_i16.Dio>()));
  gh.factory<_i24.ZodiacArticlesRepository>(
      () => _i25.ZodiacArticlesRepositoryImpl(get<_i21.ArticlesApi>()));
  gh.factory<_i26.ZodiacAuthRepository>(
      () => _i27.ZodiacAuthRepositoryImpl(get<_i22.AuthApi>()));
  gh.factory<_i28.ZodiacChatsRepository>(
      () => _i29.ZodiacChatsRepositoryImpl(get<_i23.ChatsApi>()));
  return get;
}

class _$ServicesModule extends _i30.ServicesModule {}

class _$ApiModule extends _i31.ApiModule {}
