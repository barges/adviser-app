import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../presentation/screens/add_gallery_pictures/add_gallery_pictures_screen.dart';
import '../../presentation/screens/add_note/add_note_screen.dart';
import '../../presentation/screens/advisor_preview/advisor_preview_screen.dart';
import '../../presentation/screens/balance_and_transactions/balance_and_transactions_screen.dart';
import '../../presentation/screens/brand_screen/fortunica_brand_screen.dart';
import '../../presentation/screens/chat/chat_screen.dart';
import '../../presentation/screens/customer_profile/customer_profile_screen.dart';
import '../../presentation/screens/customer_sessions/customer_sessions_screen.dart';
import '../../presentation/screens/edit_profile/edit_profile_screen.dart';
import '../../presentation/screens/force_update/force_update_screen.dart';
import '../../presentation/screens/forgot_password/forgot_password_screen.dart';
import '../../presentation/screens/gallery/gallery_pictures_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/home/tabs/account/account_screen.dart';
import '../../presentation/screens/home/tabs/dashboard_v1/dashboard_v1_screen.dart';
import '../../presentation/screens/home/tabs/sessions/sessions_screen.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/support/support_screen.dart';
import 'route_paths.dart';
import 'route_paths_fortunica.dart';

const fortunicaRoute = AutoRoute(
    page: FortunicaBrandScreen,
    path: alias,
    name: alias,
    initial: true,
    children: <AutoRoute>[
      AutoRoute(
        page: SplashScreen,
        path: RoutePathsFortunica.splashScreen,
        name: RoutePathsFortunica.splashScreen,
        initial: true,
      ),
      AutoRoute(
        page: LoginScreen,
        path: RoutePathsFortunica.loginScreen,
        name: RoutePathsFortunica.loginScreen,
      ),
      AutoRoute(
          page: HomeScreen,
          path: RoutePathsFortunica.homeScreen,
          name: RoutePathsFortunica.homeScreen,
          children: [
            AutoRoute(
              page: DashboardV1Screen,
              path: RoutePathsFortunica.dashboardScreen,
              name: RoutePathsFortunica.dashboardScreen,
            ),
            AutoRoute(
                page: SessionsScreen,
                path: RoutePathsFortunica.chatsScreen,
                name: RoutePathsFortunica.chatsScreen),
            AutoRoute(
                page: AccountScreen,
                path: RoutePathsFortunica.accountScreen,
                name: RoutePathsFortunica.accountScreen),
          ]),
      AutoRoute(
        page: AddGalleryPicturesScreen,
        path: RoutePathsFortunica.addGalleryPicturesScreen,
        name: RoutePathsFortunica.addGalleryPicturesScreen,
      ),
      AutoRoute(
        page: AddNoteScreen,
        path: RoutePathsFortunica.addNoteScreen,
        name: RoutePathsFortunica.addNoteScreen,
      ),
      AutoRoute(
        page: AdvisorPreviewScreen,
        path: RoutePathsFortunica.advisorPreviewScreen,
        name: RoutePathsFortunica.advisorPreviewScreen,
      ),
      AutoRoute(
        page: BalanceAndTransactionsScreen,
        path: RoutePathsFortunica.balanceAndTransactionsScreen,
        name: RoutePathsFortunica.balanceAndTransactionsScreen,
      ),
      AutoRoute(
        page: ChatScreen,
        path: RoutePathsFortunica.chatScreen,
        name: RoutePathsFortunica.chatScreen,
      ),
      AutoRoute(
        page: CustomerProfileScreen,
        path: RoutePathsFortunica.customerProfileScreen,
        name: RoutePathsFortunica.customerProfileScreen,
      ),
      AutoRoute(
        page: CustomerSessionsScreen,
        path: RoutePathsFortunica.customerSessionsScreen,
        name: RoutePathsFortunica.customerSessionsScreen,
      ),
      AutoRoute(
        page: EditProfileScreen,
        path: RoutePathsFortunica.editProfileScreen,
        name: RoutePathsFortunica.editProfileScreen,
      ),
      AutoRoute(
        page: ForgotPasswordScreen,
        path: RoutePathsFortunica.forgotPasswordScreen,
        name: RoutePathsFortunica.forgotPasswordScreen,
      ),
      AutoRoute(
        page: GalleryPicturesScreen,
        path: RoutePathsFortunica.galleryPicturesScreen,
        name: RoutePathsFortunica.galleryPicturesScreen,
      ),
      AutoRoute(
        page: SupportScreen,
        path: RoutePathsFortunica.supportScreen,
        name: RoutePathsFortunica.supportScreen,
      ),
      AutoRoute(
        page: ForceUpdateScreen,
        path: RoutePaths.forceUpdateScreen,
        name: RoutePaths.forceUpdateScreen,
      ),
    ]);

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page|Dialog,Route',
  routes: <AutoRoute>[
    fortunicaRoute,
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

  void popUntilRoot() {
    router.popUntilRoot();
  }

  void popUntilRouteWithPath(String path) {
    router.popUntilRouteWithPath(path);
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
