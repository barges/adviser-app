import 'package:shared_advisor_interface/infrastructure/routing/route_paths.dart';
import 'package:shared_advisor_interface/presentation/screens/all_brands/all_brands_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/force_update/force_update_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home_screen/main_home_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fortunica/infrastructure/routing/app_router.dart';
import 'package:zodiac/infrastructure/routing/app_router.dart';

///Will hold all the routes in our app
@AdaptiveAutoRouter(
  replaceInRouteName: 'Page|Dialog,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: MainHomeScreen,
      path: RoutePaths.homeScreen,
      initial: true,
      children: [
        fortunicaRoute,
        zodiacRoute,
      ],
    ),
    AutoRoute(
      page: ForceUpdateScreen,
      path: RoutePaths.forceUpdateScreen,
      name: RoutePaths.forceUpdateScreen,
    ),
    AutoRoute(
      page: AllBrandsScreen,
      path: RoutePaths.allBrandsScreen,
      name: RoutePaths.allBrandsScreen,
    ),
  ],
)
class $MainAppRouter {}

extension ContextExt on BuildContext {
  Future<T?> push<T>({required PageRouteInfo route}) async {
    return await router.push<T>(route);
  }

  Future<T?> pushRoot<T>({required PageRouteInfo route}) async {
    return await router.root.push<T>(route);
  }

  Future<T?> pushNamed<T>({required String path}) async {
    return await router.pushNamed<T>(path);
  }

  Future<T?> replace<T extends Object?>({required PageRouteInfo route}) async {
    return await router.replace<T>(route);
  }

  Future<void> replaceAll(
    List<PageRouteInfo> routes, {
    OnNavigationFailure? onFailure,
  }) async {
    await router.replaceAll(routes, onFailure: onFailure);
  }

  Future<T?> pushAndPopUntil<T extends Object?>(
    PageRouteInfo route, {
    required RoutePredicate predicate,
    OnNavigationFailure? onFailure,
  }) async {
   return await router.pushAndPopUntil(
      route,
      predicate: predicate,
      onFailure: onFailure,
    );
  }

  Future<void> replaceAllRoot(
    List<PageRouteInfo> routes, {
    OnNavigationFailure? onFailure,
  }) async {
    await router.root.replaceAll(routes, onFailure: onFailure);
  }

  Future<bool> pop<T extends Object?>([T? result]) async {
    return await router.pop(result);
  }

  Future<bool> popRoot<T extends Object?>([T? result]) async {
    return await router.root.pop(result);
  }

  void popForced<T extends Object?>([T? result]) async {
    router.popForced(result);
  }

  String get currentRoutePath => router.current.path;

  String? get previousRoutePath {
    String? previousRoutePath;
    final int routeStackLength = router.stack.length;
    if (routeStackLength > 1) {
      previousRoutePath = router.stack[routeStackLength - 2].routeData.path;
    }
    return previousRoutePath;
  }
}
