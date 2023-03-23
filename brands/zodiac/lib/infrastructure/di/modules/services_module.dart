

import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ServicesModule {

  @singleton
  BrandManager get brandManager =>
      globalGetIt.get<BrandManager>();

  @singleton
  MainCubit get mainCubit =>
      globalGetIt.get<MainCubit>();

  @singleton
  GlobalCachingManager get globalCachingManager =>
      globalGetIt.get<GlobalCachingManager>();

  @singleton
  AppRouter get navigationService =>
      globalGetIt.get<AppRouter>();

  @singleton
  ConnectivityService get connectivityService =>
      globalGetIt.get<ConnectivityService>();
    // fortunicaGetIt.registerLazySingleton<AuthRepository>(
    //     () => AuthRepositoryImpl(fortunicaGetIt.get<AuthApi>()));
    // fortunicaGetIt.registerLazySingleton<UserRepository>(() =>
    //     UserRepositoryImpl(fortunicaGetIt.get<UserApi>(), fortunicaGetIt.get<FortunicaCachingManager>()));
    // fortunicaGetIt.registerLazySingleton<ChatsRepository>(
    //     () => ChatsRepositoryImpl(getIt.get<ChatsApi>()));
    // fortunicaGetIt.registerLazySingleton<CustomerRepository>(
    //     () => CustomerRepositoryImpl(getIt.get<CustomerApi>()));

}
