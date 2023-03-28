// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i15;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart'
    as _i8;
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart'
    as _i4;
import 'package:shared_advisor_interface/main_cubit.dart' as _i9;
import 'package:shared_advisor_interface/services/check_permission_service.dart'
    as _i5;
import 'package:shared_advisor_interface/services/connectivity_service.dart'
    as _i6;
import 'package:shared_advisor_interface/services/fresh_chat_service.dart'
    as _i7;
import 'package:shared_advisor_interface/services/push_notification/push_notification_manager.dart'
    as _i10;

import '../../data/cache/zodiac_caching_manager.dart' as _i11;
import '../../data/cache/zodiac_caching_manager_impl.dart' as _i12;
import '../../data/data_source/remote/authentication_services.dart' as _i3;
import '../../data/network/api/articles_api.dart' as _i22;
import '../../data/network/api/auth_api.dart' as _i23;
import '../../data/network/api/chats_api.dart' as _i24;
import '../../data/network/api/services_api.dart' as _i16;
import '../../data/network/api/user_api.dart' as _i17;
import '../../data/network/websocket_manager/websocket_manager.dart' as _i18;
import '../../data/network/websocket_manager/websocket_manager_impl.dart'
    as _i19;
import '../../data/repository_impl/zodiac_articles_repository_impl.dart'
    as _i26;
import '../../data/repository_impl/zodiac_auth_repository_impl.dart' as _i28;
import '../../data/repository_impl/zodiac_chats_repository_impl.dart' as _i30;
import '../../data/repository_impl/zodiac_user_repository_impl.dart' as _i21;
import '../../domain/repositories/zodiac_articles_repository.dart' as _i25;
import '../../domain/repositories/zodiac_auth_repository.dart' as _i27;
import '../../domain/repositories/zodiac_chats_repository.dart' as _i29;
import '../../domain/repositories/zodiac_user_repository.dart' as _i20;
import '../../zodiac_main_cubit.dart' as _i13;
import 'dio_interceptors/app_interceptor.dart' as _i14;
import 'modules/api_module.dart' as _i32;
import 'modules/services_module.dart'
    as _i31; // ignore_for_file: unnecessary_lambdas

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
  gh.factory<_i3.AuthenticationServices>(() => _i3.AuthenticationServices());
  gh.singleton<_i4.BrandManager>(servicesModule.brandManager);
  gh.singleton<_i5.CheckPermissionService>(
      servicesModule.checkPermissionService);
  gh.singleton<_i6.ConnectivityService>(servicesModule.connectivityService);
  gh.singleton<_i7.FreshChatService>(servicesModule.freshChatService);
  gh.singleton<_i8.GlobalCachingManager>(servicesModule.globalCachingManager);
  gh.singleton<_i9.MainCubit>(servicesModule.mainCubit);
  gh.singleton<_i10.PushNotificationManager>(
      servicesModule.pushNotificationManager);
  gh.factory<_i11.ZodiacCachingManager>(() => _i12.ZodiacCachingManagerImpl());
  gh.singleton<_i13.ZodiacMainCubit>(_i13.ZodiacMainCubit());
  gh.singleton<_i14.AppInterceptor>(_i14.AppInterceptor(
    get<_i9.MainCubit>(),
    get<_i13.ZodiacMainCubit>(),
    get<_i8.GlobalCachingManager>(),
  ));
  await gh.singletonAsync<_i15.Dio>(
    () => apiModule.initDio(
      get<_i8.GlobalCachingManager>(),
      get<_i14.AppInterceptor>(),
    ),
    preResolve: true,
  );
  gh.factory<_i16.ServicesApi>(() => _i16.ServicesApi(get<_i15.Dio>()));
  gh.factory<_i17.UserApi>(() => _i17.UserApi(get<_i15.Dio>()));
  gh.factory<_i18.WebSocketManager>(
      () => _i19.WebSocketManagerImpl(get<_i13.ZodiacMainCubit>()));
  gh.factory<_i20.ZodiacUserRepository>(
      () => _i21.ZodiacUserRepositoryImpl(get<_i17.UserApi>()));
  gh.factory<_i22.ArticlesApi>(() => _i22.ArticlesApi(get<_i15.Dio>()));
  gh.factory<_i23.AuthApi>(() => _i23.AuthApi(get<_i15.Dio>()));
  gh.factory<_i24.ChatsApi>(() => _i24.ChatsApi(get<_i15.Dio>()));
  gh.factory<_i25.ZodiacArticlesRepository>(
      () => _i26.ZodiacAuthRepositoryImpl(get<_i22.ArticlesApi>()));
  gh.factory<_i27.ZodiacAuthRepository>(
      () => _i28.ZodiacAuthRepositoryImpl(get<_i23.AuthApi>()));
  gh.factory<_i29.ZodiacChatsRepository>(
      () => _i30.ZodiacChatsRepositoryImpl(get<_i24.ChatsApi>()));
  return get;
}

class _$ServicesModule extends _i31.ServicesModule {}

class _$ApiModule extends _i32.ApiModule {}
