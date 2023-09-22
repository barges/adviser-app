// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i19;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart'
    as _i9;
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart'
    as _i5;
import 'package:shared_advisor_interface/main_cubit.dart' as _i10;
import 'package:shared_advisor_interface/services/audio/audio_player_service.dart'
    as _i3;
import 'package:shared_advisor_interface/services/audio/audio_recorder_service.dart'
    as _i4;
import 'package:shared_advisor_interface/services/check_permission_service.dart'
    as _i6;
import 'package:shared_advisor_interface/services/connectivity_service.dart'
    as _i7;
import 'package:shared_advisor_interface/services/fresh_chat_service.dart'
    as _i8;
import 'package:shared_advisor_interface/services/push_notification/push_notification_manager.dart'
    as _i11;
import 'package:shared_advisor_interface/services/sound_mode_service.dart'
    as _i12;

import '../../data/cache/zodiac_caching_manager.dart' as _i13;
import '../../data/cache/zodiac_caching_manager_impl.dart' as _i14;
import '../../data/models/settings/phone.dart' as _i38;
import '../../data/network/api/articles_api.dart' as _i30;
import '../../data/network/api/auth_api.dart' as _i31;
import '../../data/network/api/canned_messages_api.dart' as _i32;
import '../../data/network/api/chat_api.dart' as _i33;
import '../../data/network/api/coupons_api.dart' as _i35;
import '../../data/network/api/services_api.dart' as _i20;
import '../../data/network/api/sessions_api.dart' as _i21;
import '../../data/network/api/user_api.dart' as _i22;
import '../../data/repository_impl/zodiac_articles_repository_impl.dart'
    as _i41;
import '../../data/repository_impl/zodiac_auth_repository_impl.dart' as _i43;
import '../../data/repository_impl/zodiac_canned_messages_repository_impl.dart'
    as _i45;
import '../../data/repository_impl/zodiac_chat_repository_impl.dart' as _i47;
import '../../data/repository_impl/zodiac_coupons_repository_impl.dart' as _i49;
import '../../data/repository_impl/zodiac_services_repository_impl.dart'
    as _i24;
import '../../data/repository_impl/zodiac_sessions_repository_impl.dart'
    as _i26;
import '../../data/repository_impl/zodiac_user_repository_impl.dart' as _i28;
import '../../domain/repositories/zodiac_articles_repository.dart' as _i40;
import '../../domain/repositories/zodiac_auth_repository.dart' as _i42;
import '../../domain/repositories/zodiac_canned_messages_repository.dart'
    as _i44;
import '../../domain/repositories/zodiac_chat_repository.dart' as _i46;
import '../../domain/repositories/zodiac_coupons_repository.dart' as _i48;
import '../../domain/repositories/zodiac_sessions_repository.dart' as _i25;
import '../../domain/repositories/zodiac_sevices_repository.dart' as _i23;
import '../../domain/repositories/zodiac_user_repository.dart' as _i27;
import '../../presentation/screens/add_service/add_service_cubit.dart' as _i29;
import '../../presentation/screens/chat/chat_cubit.dart' as _i34;
import '../../presentation/screens/edit_service/edit_service_cubit.dart'
    as _i36;
import '../../presentation/screens/phone_number/phone_number_cubit.dart'
    as _i37;
import '../../presentation/screens/services_messages/canned_messages/canned_messages_cubit.dart'
    as _i50;
import '../../presentation/screens/services_messages/services/services_cubit.dart'
    as _i39;
import '../../services/websocket_manager/websocket_manager.dart' as _i16;
import '../../services/websocket_manager/websocket_manager_impl.dart' as _i17;
import '../../zodiac_main_cubit.dart' as _i15;
import 'dio_interceptors/app_interceptor.dart' as _i18;
import 'modules/api_module.dart' as _i52;
import 'modules/services_module.dart' as _i51;

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
  gh.factory<_i3.AudioPlayerService>(() => servicesModule.audioPlayerService);
  gh.factory<_i4.AudioRecorderService>(
      () => servicesModule.audioRecorderService);
  gh.singleton<_i5.BrandManager>(servicesModule.brandManager);
  gh.singleton<_i6.CheckPermissionService>(
      servicesModule.checkPermissionService);
  gh.singleton<_i7.ConnectivityService>(servicesModule.connectivityService);
  gh.singleton<_i8.FreshChatService>(servicesModule.freshChatService);
  gh.singleton<_i9.GlobalCachingManager>(servicesModule.globalCachingManager);
  gh.singleton<_i10.MainCubit>(servicesModule.mainCubit);
  gh.singleton<_i11.PushNotificationManager>(
      servicesModule.pushNotificationManager);
  gh.singleton<_i12.SoundModeService>(servicesModule.silentModeService);
  gh.singleton<_i13.ZodiacCachingManager>(_i14.ZodiacCachingManagerImpl());
  gh.singleton<_i15.ZodiacMainCubit>(
      _i15.ZodiacMainCubit(gh<_i7.ConnectivityService>()));
  gh.singleton<_i16.WebSocketManager>(_i17.WebSocketManagerImpl(
    gh<_i15.ZodiacMainCubit>(),
    gh<_i13.ZodiacCachingManager>(),
  ));
  gh.singleton<_i18.AppInterceptor>(_i18.AppInterceptor(
    gh<_i10.MainCubit>(),
    gh<_i15.ZodiacMainCubit>(),
    gh<_i13.ZodiacCachingManager>(),
    gh<_i16.WebSocketManager>(),
  ));
  await gh.singletonAsync<_i19.Dio>(
    () => apiModule.initDio(
      gh<_i9.GlobalCachingManager>(),
      gh<_i18.AppInterceptor>(),
    ),
    preResolve: true,
  );
  gh.factory<_i20.ServicesApi>(() => _i20.ServicesApi(gh<_i19.Dio>()));
  gh.factory<_i21.SessionsApi>(() => _i21.SessionsApi(gh<_i19.Dio>()));
  gh.factory<_i22.UserApi>(() => _i22.UserApi(gh<_i19.Dio>()));
  gh.factory<_i23.ZodiacServicesRepository>(
      () => _i24.ZodiacServicesRepositoryImpl(gh<_i20.ServicesApi>()));
  gh.factory<_i25.ZodiacSessionsRepository>(
      () => _i26.ZodiacChatsRepositoryImpl(gh<_i21.SessionsApi>()));
  gh.factory<_i27.ZodiacUserRepository>(
      () => _i28.ZodiacUserRepositoryImpl(gh<_i22.UserApi>()));
  gh.factoryParam<_i29.AddServiceCubit, bool, bool>((
    hasOfflineService,
    hasOnlineService,
  ) =>
      _i29.AddServiceCubit(
        gh<_i13.ZodiacCachingManager>(),
        gh<_i23.ZodiacServicesRepository>(),
        gh<_i27.ZodiacUserRepository>(),
        gh<_i9.GlobalCachingManager>(),
        hasOfflineService,
        hasOnlineService,
      ));
  gh.factory<_i30.ArticlesApi>(() => _i30.ArticlesApi(gh<_i19.Dio>()));
  gh.factory<_i31.AuthApi>(() => _i31.AuthApi(gh<_i19.Dio>()));
  gh.factory<_i32.CannedMessagesApi>(
      () => _i32.CannedMessagesApi(gh<_i19.Dio>()));
  gh.factory<_i33.ChatApi>(() => _i33.ChatApi(gh<_i19.Dio>()));
  gh.factoryParam<_i34.ChatCubit, _i34.ChatCubitParams, dynamic>((
    chatCubitParams,
    _,
  ) =>
      _i34.ChatCubit(
        chatCubitParams,
        gh<_i13.ZodiacCachingManager>(),
        gh<_i16.WebSocketManager>(),
        gh<_i27.ZodiacUserRepository>(),
        gh<_i10.MainCubit>(),
        gh<_i15.ZodiacMainCubit>(),
        gh<_i6.CheckPermissionService>(),
        gh<_i3.AudioPlayerService>(),
        gh<_i4.AudioRecorderService>(),
      ));
  gh.factory<_i35.CouponsApi>(() => _i35.CouponsApi(gh<_i19.Dio>()));
  gh.factoryParam<_i36.EditServiceCubit, int, dynamic>((
    serviceId,
    _,
  ) =>
      _i36.EditServiceCubit(
        serviceId: serviceId,
        servicesRepository: gh<_i23.ZodiacServicesRepository>(),
        zodiacCachingManager: gh<_i13.ZodiacCachingManager>(),
        userRepository: gh<_i27.ZodiacUserRepository>(),
      ));
  gh.factoryParam<_i37.PhoneNumberCubit, String?, _i38.Phone>((
    _siteKey,
    _phone,
  ) =>
      _i37.PhoneNumberCubit(
        _siteKey,
        _phone,
        gh<_i10.MainCubit>(),
        gh<_i15.ZodiacMainCubit>(),
        gh<_i27.ZodiacUserRepository>(),
      ));
  gh.factory<_i39.ServicesCubit>(() => _i39.ServicesCubit(
        gh<_i15.ZodiacMainCubit>(),
        gh<_i23.ZodiacServicesRepository>(),
      ));
  gh.factory<_i40.ZodiacArticlesRepository>(
      () => _i41.ZodiacArticlesRepositoryImpl(gh<_i30.ArticlesApi>()));
  gh.factory<_i42.ZodiacAuthRepository>(
      () => _i43.ZodiacAuthRepositoryImpl(gh<_i31.AuthApi>()));
  gh.factory<_i44.ZodiacCannedMessagesRepository>(() =>
      _i45.ZodiacCannedMessagesRepositoryImpl(gh<_i32.CannedMessagesApi>()));
  gh.factory<_i46.ZodiacChatRepository>(
      () => _i47.ZodiacChatRepositoryImpl(gh<_i33.ChatApi>()));
  gh.factory<_i48.ZodiacCouponsRepository>(
      () => _i49.ZodiacCouponsRepositoryImpl(gh<_i35.CouponsApi>()));
  gh.factory<_i50.CannedMessagesCubit>(() =>
      _i50.CannedMessagesCubit(gh<_i44.ZodiacCannedMessagesRepository>()));
  return getIt;
}

class _$ServicesModule extends _i51.ServicesModule {}

class _$ApiModule extends _i52.ApiModule {}
