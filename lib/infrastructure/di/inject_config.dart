import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager_impl.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:get_it/get_it.dart';
import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';

import 'inject_config.config.dart';
import 'brand_manager.dart';
import '../routing/app_router.gr.dart';

import 'package:shared_advisor_interface/infrastructure/brands/base_router.dart';

///Configuration file to get started with injectable and get it

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
Future<void> configureDependencies() async => $initGetIt(globalGetIt);

@module
abstract class RegisterModule {
  final brandManager = BrandManager(Configuration.brands, MainAppRouter());

  @Injectable(as: Key)
  UniqueKey get key;

  // @singleton
  // RootStackRouter get appRouter => brandManager.router;

  @singleton
  AppRouter get navigationService => AppRouterImpl();
}
