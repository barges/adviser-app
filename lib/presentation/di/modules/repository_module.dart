import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/network/api/auth_api.dart';
import 'package:shared_advisor_interface/data/network/api/chats_api.dart';
import 'package:shared_advisor_interface/data/network/api/customer_api.dart';
import 'package:shared_advisor_interface/data/network/api/user_api.dart';
import 'package:shared_advisor_interface/data/repositories/auth_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/chats_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/customer_repository_impl.dart';
import 'package:shared_advisor_interface/data/repositories/user_repository_impl.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';

import '../../../../main.dart';
import 'module.dart';

class RepositoryModule implements Module {
  @override
  Future<void> dependency() async {
    getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt.get<AuthApi>()));
    getIt.registerLazySingleton<UserRepository>(() =>
        UserRepositoryImpl(getIt.get<UserApi>(), getIt.get<CachingManager>()));
    getIt.registerLazySingleton<ChatsRepository>(
        () => ChatsRepositoryImpl(getIt.get<ChatsApi>()));
    getIt.registerLazySingleton<CustomerRepository>(
        () => CustomerRepositoryImpl(getIt.get<CustomerApi>()));
  }
}
