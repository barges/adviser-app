import 'package:shared_advisor_interface/configuration.dart';
import 'package:auto_route/auto_route.dart';
import 'package:zodiac/infrastructure/routing/route_paths.dart';
import 'package:zodiac/presentation/screens/brand_screen/zodiac_brand_screen.dart';
import 'package:zodiac/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:zodiac/presentation/screens/gallery/gallery_pictures_screen.dart';
import 'package:zodiac/presentation/screens/home/home_screen.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_screen.dart';
import 'package:zodiac/presentation/screens/home/tabs/articles/articles_screen.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/dashboard_screen.dart';
import 'package:zodiac/presentation/screens/home/tabs/sessions/sessions_screen.dart';
import 'package:zodiac/presentation/screens/login/login_screen.dart';
import 'package:zodiac/presentation/screens/notifications/notifications_screen.dart';
import 'package:zodiac/presentation/screens/profile/profile.dart';
import 'package:zodiac/presentation/screens/reviews/reviews_screen.dart';
import 'package:zodiac/presentation/wrappers/auth_wrapper/zodiac_auth_wrapper.dart';

const zodiacRoute = AutoRoute(
  page: ZodiacBrandScreen,
  path: Brand.zodiacAlias,
  name: Brand.zodiacAlias,
  children: <AutoRoute>[
    AutoRoute(
        initial: true,
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
    AutoRoute(
        page: HomeScreen,
        path: RoutePaths.homeScreen,
        name: RoutePaths.homeScreen,
        children: [
          AutoRoute(
              page: DashboardScreen,
              path: RoutePaths.dashboardScreen,
              name: RoutePaths.dashboardScreen),
          AutoRoute(
              page: SessionsScreen,
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
    AutoRoute(
        page: ProfileScreen,
        path: RoutePaths.profileScreen,
        name: RoutePaths.profileScreen),
    AutoRoute(
        page: GalleryPicturesScreen,
        path: RoutePaths.galleryScreen,
        name: RoutePaths.galleryScreen),
    AutoRoute(
      page: ForgotPasswordScreen,
      path: RoutePaths.forgotPasswordScreen,
      name: RoutePaths.forgotPasswordScreen,
    ),
    AutoRoute(
      page: NotificationsScreen,
      path: RoutePaths.notificationsScreen,
      name: RoutePaths.notificationsScreen,
    ),
    AutoRoute(
      page: ReviewsScreen,
      path: RoutePaths.reviewsScreen,
      name: RoutePaths.reviewsScreen,
    ),
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
