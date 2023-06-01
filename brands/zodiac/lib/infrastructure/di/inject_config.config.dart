// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i18;
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
    as _i10;
import 'package:shared_advisor_interface/services/sound_mode_service.dart'
    as _i11;

import '../../data/cache/zodiac_caching_manager.dart' as _i12;
import '../../data/cache/zodiac_caching_manager_impl.dart' as _i13;
import '../../data/network/api/articles_api.dart' as _i26;
import '../../data/network/api/auth_api.dart' as _i27;
import '../../data/network/api/chat_api.dart' as _i28;
import '../../data/network/api/services_api.dart' as _i19;
import '../../data/network/api/sessions_api.dart' as _i20;
import '../../data/network/api/user_api.dart' as _i21;
import '../../data/repository_impl/zodiac_articles_repository_impl.dart'
    as _i31;
import '../../data/repository_impl/zodiac_auth_repository_impl.dart' as _i33;
import '../../data/repository_impl/zodiac_chat_repository_impl.dart' as _i35;
import '../../data/repository_impl/zodiac_sessions_repository_impl.dart'
    as _i23;
import '../../data/repository_impl/zodiac_user_repository_impl.dart' as _i25;
import '../../domain/repositories/zodiac_articles_repository.dart' as _i30;
import '../../domain/repositories/zodiac_auth_repository.dart' as _i32;
import '../../domain/repositories/zodiac_chat_repository.dart' as _i34;
import '../../domain/repositories/zodiac_sessions_repository.dart' as _i22;
import '../../domain/repositories/zodiac_user_repository.dart' as _i24;
import '../../presentation/screens/chat/chat_cubit.dart' as _i29;
import '../../services/phone_country_codes_service.dart' as _i9;
import '../../services/websocket_manager/websocket_manager.dart' as _i15;
import '../../services/websocket_manager/websocket_manager_impl.dart' as _i16;
import '../../zodiac_main_cubit.dart' as _i14;
import 'dio_interceptors/app_interceptor.dart' as _i17;
import 'modules/api_module.dart' as _i37;
import 'modules/services_module.dart' as _i36;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    getIt,
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
  gh.lazySingleton<_i9.PhoneCountryCodesService>(
      () => _i9.PhoneCountryCodesService());
  gh.singleton<_i10.PushNotificationManager>(
      servicesModule.pushNotificationManager);
  gh.singleton<_i11.SoundModeService>(servicesModule.silentModeService);
  gh.singleton<_i12.ZodiacCachingManager>(_i13.ZodiacCachingManagerImpl());
  gh.singleton<_i14.ZodiacMainCubit>(
      _i14.ZodiacMainCubit(gh<_i5.ConnectivityService>()));
  gh.singleton<_i15.WebSocketManager>(_i16.WebSocketManagerImpl(
    gh<_i14.ZodiacMainCubit>(),
    gh<_i12.ZodiacCachingManager>(),
  ));
  gh.singleton<_i17.AppInterceptor>(_i17.AppInterceptor(
    gh<_i8.MainCubit>(),
    gh<_i14.ZodiacMainCubit>(),
    gh<_i12.ZodiacCachingManager>(),
    gh<_i15.WebSocketManager>(),
  ));
  await gh.singletonAsync<_i18.Dio>(
    () => apiModule.initDio(
      gh<_i7.GlobalCachingManager>(),
      gh<_i17.AppInterceptor>(),
    ),
    preResolve: true,
  );
  gh.factory<_i19.ServicesApi>(() => _i19.ServicesApi(gh<_i18.Dio>()));
  gh.factory<_i20.SessionsApi>(() => _i20.SessionsApi(gh<_i18.Dio>()));
  gh.factory<_i21.UserApi>(() => _i21.UserApi(gh<_i18.Dio>()));
  gh.factory<_i22.ZodiacSessionsRepository>(
      () => _i23.ZodiacChatsRepositoryImpl(gh<_i20.SessionsApi>()));
  gh.factory<_i24.ZodiacUserRepository>(
      () => _i25.ZodiacUserRepositoryImpl(gh<_i21.UserApi>()));
  gh.factory<_i26.ArticlesApi>(() => _i26.ArticlesApi(gh<_i18.Dio>()));
  gh.factory<_i27.AuthApi>(() => _i27.AuthApi(gh<_i18.Dio>()));
  gh.factory<_i28.ChatApi>(() => _i28.ChatApi(gh<_i18.Dio>()));
  gh.factoryParam<_i29.ChatCubit, _i29.ChatCubitParams, dynamic>((
    chatCubitParams,
    _,
  ) =>
      _i29.ChatCubit(
        chatCubitParams,
        gh<_i12.ZodiacCachingManager>(),
        gh<_i15.WebSocketManager>(),
        gh<_i24.ZodiacUserRepository>(),
        gh<_i14.ZodiacMainCubit>(),
      ));
  gh.factory<_i30.ZodiacArticlesRepository>(
      () => _i31.ZodiacArticlesRepositoryImpl(gh<_i26.ArticlesApi>()));
  gh.factory<_i32.ZodiacAuthRepository>(
      () => _i33.ZodiacAuthRepositoryImpl(gh<_i27.AuthApi>()));
  gh.factory<_i34.ZodiacChatRepository>(
      () => _i35.ZodiacChatRepositoryImpl(gh<_i28.ChatApi>()));
  return getIt;
}

class _$ServicesModule extends _i36.ServicesModule {}

class _$ApiModule extends _i37.ApiModule {}
