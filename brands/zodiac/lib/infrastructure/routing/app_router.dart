import 'package:shared_advisor_interface/configuration.dart';
import 'package:auto_route/auto_route.dart';
import 'package:zodiac/infrastructure/routing/route_paths.dart';
import 'package:zodiac/presentation/screens/account_screen/account_screen.dart';
import 'package:zodiac/presentation/screens/articles_screen/articles_screen.dart';
import 'package:zodiac/presentation/screens/brand_screen/zodiac_brand_screen.dart';
import 'package:zodiac/presentation/screens/chats_screen/chats_screen.dart';
import 'package:zodiac/presentation/screens/dashboard_screen/dashboard_screen.dart';
import 'package:zodiac/presentation/screens/home_screen/home_screen.dart';
import 'package:zodiac/presentation/screens/login/login_screen.dart';
import 'package:zodiac/presentation/screens/profile/profile.dart';
import 'package:zodiac/presentation/wrappers/auth_wrapper/zodiac_auth_wrapper.dart';
import 'package:zodiac/presentation/wrappers/main_wrapper/zodiac_home_wrapper.dart';

const zodiacRoute = AutoRoute(
  page: ZodiacBrandScreen,
  path: Brand.zodiacAlias,
  name: Brand.zodiacAlias,
  children: <AutoRoute>[
    AutoRoute(
        initial: true,
        page: ZodiacHomeWrapper,
        path: RoutePaths.mainScreen,
        name: RoutePaths.mainScreen,
        children: [
          AutoRoute(
              initial: true,
              page: HomeScreen,
              path: RoutePaths.homeScreen,
              name: RoutePaths.homeScreen,
              children: [
                AutoRoute(
                    page: DashboardScreen,
                    path: RoutePaths.dashboardScreen,
                    name: RoutePaths.dashboardScreen),
                AutoRoute(
                    page: ChatsScreen,
                    path: RoutePaths.chatsScreen,
                    name: RoutePaths.chatsScreen),
                AutoRoute(
                  page: AccountScreen,
                  path: RoutePaths.accountScreen,
                  name: RoutePaths.accountScreen,
                ),
                AutoRoute(
                    page: ArticlesScreen,
                    path: RoutePaths.articlesScreen,
                    name: RoutePaths.articlesScreen),
              ]),
        ]),
    AutoRoute(
        page: ProfileScreen,
        path: RoutePaths.profileScreen,
        name: RoutePaths.profileScreen),
    AutoRoute(
        page: ZodiacAuthWrapper,
        path: RoutePaths.authScreen,
        name: RoutePaths.authScreen,
        children: [
          AutoRoute(
            initial: true,
            page: LoginScreen,
            path: RoutePaths.loginScreen,
            name: RoutePaths.loginScreen,
          )
        ]),
  ],
);

// @AdaptiveAutoRouter(
//   replaceInRouteName: 'Page|Dialog|Screen,Route',
//   routes: <AutoRoute>[
//     AutoRoute(
//       page: ZodiacBrandScreen,
//       path: Brand.zodiacAlias,
//       name: Brand.zodiacAlias,
//       children: <AutoRoute>[
//         AutoRoute(
//             initial: true,
//             page: MainWrapper,
//             path: '',
//             name: '${Brand.zodiacAlias}${RoutePaths.mainScreen}',
//             children: [
//               AutoRoute(
//                   initial: true,
//                   page: HomeScreen,
//                   path: RoutePaths.homeScreen,
//                   name: '${Brand.zodiacAlias}${RoutePaths.homeScreen}',
//                   children: [
//                     AutoRoute(
//                         page: DashboardScreen,
//                         path: RoutePaths.dashboardScreen,
//                         name:
//                             '${Brand.zodiacAlias}${RoutePaths.dashboardScreen}'),
//                     AutoRoute(
//                         page: ChatsScreen,
//                         path: RoutePaths.chatsScreen,
//                         name: '${Brand.zodiacAlias}${RoutePaths.chatsScreen}'),
//                     AutoRoute(
//                         page: AccountScreen,
//                         path: RoutePaths.accountScreen,
//                         name:
//                             '${Brand.zodiacAlias}${RoutePaths.accountScreen}'),
//                     AutoRoute(
//                         page: ArticlesScreen,
//                         path: RoutePaths.articlesScreen,
//                         name:
//                             '${Brand.zodiacAlias}${RoutePaths.articlesScreen}'),
//                   ]),
//             ]),
//         AutoRoute(
//             page: AuthWrapper,
//             path: RoutePaths.authScreen,
//             name: '${Brand.zodiacAlias}${RoutePaths.authScreen}',
//             children: [
//               AutoRoute(
//                 initial: true,
//                 page: AuthScreen,
//                 path: RoutePaths.signInScreen,
//                 name: '${Brand.zodiacAlias}${RoutePaths.signInScreen}',
//               )
//             ]),
//       ],
//     )
//   ],
// )
// class $ZodiacAppRouter {}
