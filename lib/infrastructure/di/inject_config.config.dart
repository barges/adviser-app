// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i17;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/cache/fortunica_caching_manager.dart' as _i7;
import '../../data/cache/fortunica_caching_manager_impl.dart' as _i8;
import '../../data/cache/secure_storage_manager.dart' as _i13;
import '../../data/cache/secure_storage_manager_impl.dart' as _i14;
import '../../data/network/api/auth_api.dart' as _i19;
import '../../data/network/api/chats_api.dart' as _i20;
import '../../data/network/api/customer_api.dart' as _i21;
import '../../data/network/api/user_api.dart' as _i18;
import '../../data/repository_impl/fortunica_auth_repository_impl.dart' as _i23;
import '../../data/repository_impl/fortunica_chats_repository_impl.dart'
    as _i25;
import '../../data/repository_impl/fortunica_customer_repository_impl.dart'
    as _i27;
import '../../data/repository_impl/fortunica_user_repository_impl.dart' as _i29;
import '../../domain/repositories/fortunica_auth_repository.dart' as _i22;
import '../../domain/repositories/fortunica_chats_repository.dart' as _i24;
import '../../domain/repositories/fortunica_customer_repository.dart' as _i26;
import '../../domain/repositories/fortunica_user_repository.dart' as _i28;
import '../../main_cubit.dart' as _i10;
import '../../presentation/screens/balance_and_transactions/balance_and_transactions_cubit.dart'
    as _i30;
import '../../services/audio/audio_player_service.dart' as _i3;
import '../../services/audio/audio_recorder_service.dart' as _i4;
import '../../services/check_permission_service.dart' as _i16;
import '../../services/connectivity_service.dart' as _i5;
import '../../services/dynamic_link_service.dart' as _i6;
import '../../services/fresh_chat_service.dart' as _i9;
import '../../services/push_notification/push_notification_manager.dart'
    as _i11;
import '../../services/push_notification/push_notification_manager_impl.dart'
    as _i12;
import 'dio_interceptors/app_interceptor.dart' as _i15;
import 'modules/api_module.dart' as _i31;

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
  final apiModule = _$ApiModule();
  gh.factory<_i3.AudioPlayerService>(() => _i3.AudioPlayerServiceImpl());
  gh.factory<_i4.AudioRecorderService>(() => _i4.AudioRecorderServiceImp());
  gh.singleton<_i5.ConnectivityService>(_i5.ConnectivityService());
  gh.singleton<_i6.DynamicLinkService>(_i6.DynamicLinkService());
  gh.singleton<_i7.FortunicaCachingManager>(_i8.FortunicaCachingManagerImpl());
  gh.singleton<_i9.FreshChatService>(_i9.FreshChatServiceImpl());
  gh.singleton<_i10.MainCubit>(_i10.MainCubit(
    gh<_i7.FortunicaCachingManager>(),
    gh<_i5.ConnectivityService>(),
  ));
  gh.singleton<_i11.PushNotificationManager>(
      _i12.PushNotificationManagerImpl());
  gh.singleton<_i13.SecureStorageManager>(_i14.SecureStorageManagerImpl());
  gh.singleton<_i15.AppInterceptor>(_i15.AppInterceptor(
    gh<_i10.MainCubit>(),
    gh<_i7.FortunicaCachingManager>(),
  ));
  gh.singleton<_i16.CheckPermissionService>(
      _i16.CheckPermissionService(gh<_i7.FortunicaCachingManager>()));
  await gh.singletonAsync<_i17.Dio>(
    () => apiModule.initDio(
      gh<_i7.FortunicaCachingManager>(),
      gh<_i15.AppInterceptor>(),
    ),
    preResolve: true,
  );
  gh.factory<_i18.UserApi>(() => _i18.UserApi(gh<_i17.Dio>()));
  gh.factory<_i19.AuthApi>(() => _i19.AuthApi(gh<_i17.Dio>()));
  gh.factory<_i20.ChatsApi>(() => _i20.ChatsApi(gh<_i17.Dio>()));
  gh.factory<_i21.CustomerApi>(() => _i21.CustomerApi(gh<_i17.Dio>()));
  gh.factory<_i22.FortunicaAuthRepository>(
      () => _i23.FortunicaAuthRepositoryImpl(gh<_i19.AuthApi>()));
  gh.factory<_i24.FortunicaChatsRepository>(
      () => _i25.FortunicaChatsRepositoryImpl(gh<_i20.ChatsApi>()));
  gh.factory<_i26.FortunicaCustomerRepository>(
      () => _i27.FortunicaCustomerRepositoryImpl(gh<_i21.CustomerApi>()));
  gh.factory<_i28.FortunicaUserRepository>(
      () => _i29.FortunicaUserRepositoryImpl(
            gh<_i18.UserApi>(),
            gh<_i7.FortunicaCachingManager>(),
          ));
  gh.factory<_i30.BalanceAndTransactionsCubit>(
      () => _i30.BalanceAndTransactionsCubit(
            gh<_i7.FortunicaCachingManager>(),
            gh<_i28.FortunicaUserRepository>(),
            gh<_i10.MainCubit>(),
          ));
  return getIt;
}

class _$ApiModule extends _i31.ApiModule {}
