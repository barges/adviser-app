// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i16;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart'
    as _i12;
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart'
    as _i4;
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart'
    as _i3;
import 'package:shared_advisor_interface/main_cubit.dart' as _i13;
import 'package:shared_advisor_interface/services/check_permission_service.dart'
    as _i5;
import 'package:shared_advisor_interface/services/connectivity_service.dart'
    as _i6;
import 'package:shared_advisor_interface/services/dynamic_link_service.dart'
    as _i7;
import 'package:shared_advisor_interface/services/fresh_chat_service.dart'
    as _i11;
import 'package:shared_advisor_interface/services/push_notification/push_notification_manager.dart'
    as _i14;

import '../../data/cache/fortunica_caching_manager.dart' as _i8;
import '../../data/cache/fortunica_caching_manager_impl.dart' as _i9;
import '../../data/network/api/auth_api.dart' as _i18;
import '../../data/network/api/chats_api.dart' as _i19;
import '../../data/network/api/customer_api.dart' as _i20;
import '../../data/network/api/user_api.dart' as _i17;
import '../../data/repository_impl/fortunica_auth_repository_impl.dart' as _i22;
import '../../data/repository_impl/fortunica_chats_repository_impl.dart'
    as _i24;
import '../../data/repository_impl/fortunica_customer_repository_impl.dart'
    as _i26;
import '../../data/repository_impl/fortunica_user_repository_impl.dart' as _i28;
import '../../domain/repositories/fortunica_auth_repository.dart' as _i21;
import '../../domain/repositories/fortunica_chats_repository.dart' as _i23;
import '../../domain/repositories/fortunica_customer_repository.dart' as _i25;
import '../../domain/repositories/fortunica_user_repository.dart' as _i27;
import '../../fortunica_main_cubit.dart' as _i10;
import 'dio_interceptors/app_interceptor.dart' as _i15;
import 'modules/api_module.dart' as _i30;
import 'modules/services_module.dart'
    as _i29; // ignore_for_file: unnecessary_lambdas

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
  gh.singleton<_i4.BrandManager>(servicesModule.brandManager);
  gh.singleton<_i5.CheckPermissionService>(
      servicesModule.checkPermissionService);
  gh.singleton<_i6.ConnectivityService>(servicesModule.connectivityService);
  gh.singleton<_i7.DynamicLinkService>(servicesModule.dynamicLinkService);
  gh.factory<_i8.FortunicaCachingManager>(
      () => _i9.FortunicaCachingManagerImpl());
  gh.singleton<_i10.FortunicaMainCubit>(_i10.FortunicaMainCubit());
  gh.singleton<_i11.FreshChatService>(servicesModule.freshChatService);
  gh.singleton<_i12.GlobalCachingManager>(servicesModule.globalCachingManager);
  gh.singleton<_i13.MainCubit>(servicesModule.mainCubit);
  gh.singleton<_i14.PushNotificationManager>(
      servicesModule.pushNotificationManager);
  gh.singleton<_i15.AppInterceptor>(_i15.AppInterceptor(
    get<_i13.MainCubit>(),
    get<_i10.FortunicaMainCubit>(),
    get<_i8.FortunicaCachingManager>(),
  ));
  await gh.singletonAsync<_i16.Dio>(
    () => apiModule.initDio(
      get<_i8.FortunicaCachingManager>(),
      get<_i15.AppInterceptor>(),
    ),
    preResolve: true,
  );
  gh.factory<_i17.UserApi>(() => _i17.UserApi(get<_i16.Dio>()));
  gh.factory<_i18.AuthApi>(() => _i18.AuthApi(get<_i16.Dio>()));
  gh.factory<_i19.ChatsApi>(() => _i19.ChatsApi(get<_i16.Dio>()));
  gh.factory<_i20.CustomerApi>(() => _i20.CustomerApi(get<_i16.Dio>()));
  gh.factory<_i21.FortunicaAuthRepository>(
      () => _i22.FortunicaAuthRepositoryImpl(get<_i18.AuthApi>()));
  gh.factory<_i23.FortunicaChatsRepository>(
      () => _i24.FortunicaChatsRepositoryImpl(get<_i19.ChatsApi>()));
  gh.factory<_i25.FortunicaCustomerRepository>(
      () => _i26.FortunicaCustomerRepositoryImpl(get<_i20.CustomerApi>()));
  gh.factory<_i27.FortunicaUserRepository>(
      () => _i28.FortunicaUserRepositoryImpl(
            get<_i17.UserApi>(),
            get<_i8.FortunicaCachingManager>(),
          ));
  return get;
}

class _$ServicesModule extends _i29.ServicesModule {}

class _$ApiModule extends _i30.ApiModule {}
