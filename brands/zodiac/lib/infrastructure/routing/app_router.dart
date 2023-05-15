import 'package:auto_route/auto_route.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/infrastructure/routing/route_paths.dart';
import 'package:zodiac/presentation/screens/article_details_screen/article_details_screen.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/balance_and_transactions_screen.dart';
import 'package:zodiac/presentation/screens/brand_screen/zodiac_brand_screen.dart';
import 'package:zodiac/presentation/screens/chat/chat_screen.dart';
import 'package:zodiac/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:zodiac/presentation/screens/gallery/gallery_pictures_screen.dart';
import 'package:zodiac/presentation/screens/home/home_screen.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_screen.dart';
import 'package:zodiac/presentation/screens/home/tabs/articles/articles_screen.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/dashboard_screen.dart';
import 'package:zodiac/presentation/screens/home/tabs/sessions/sessions_screen.dart';
import 'package:zodiac/presentation/screens/locales_list/locales_list_screen.dart';
import 'package:zodiac/presentation/screens/login/login_screen.dart';
import 'package:zodiac/presentation/screens/notification_details/notification_details_screen.dart';
import 'package:zodiac/presentation/screens/notifications/notifications_screen.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_screen.dart';
import 'package:zodiac/presentation/screens/reviews/reviews_screen.dart';
import 'package:zodiac/presentation/screens/send_image/send_image_screen.dart';
import 'package:zodiac/presentation/screens/specialities_list/specialities_list_screen.dart';
import 'package:zodiac/presentation/screens/support/support_screen.dart';
import 'package:zodiac/presentation/wrappers/auth_wrapper/zodiac_auth_wrapper.dart';
import 'package:zodiac/zodiac.dart';

const zodiacRoute = AutoRoute(
  page: ZodiacBrandScreen,
  path: ZodiacBrand.alias,
  name: ZodiacBrand.alias,
  children: <AutoRoute>[
    AutoRoute(
        initial: true,
        page: ZodiacAuthWrapper,
        path: RoutePathsZodiac.authScreen,
        name: RoutePathsZodiac.authScreen,
        children: [
          AutoRoute(
            initial: true,
            page: LoginScreen,
            path: RoutePathsZodiac.loginScreen,
            name: RoutePathsZodiac.loginScreen,
          )
        ]),
    AutoRoute(
        page: HomeScreen,
        path: RoutePathsZodiac.homeScreen,
        name: RoutePathsZodiac.homeScreen,
        children: [
          AutoRoute(
              page: DashboardScreen,
              path: RoutePathsZodiac.dashboardScreen,
              name: RoutePathsZodiac.dashboardScreen),
          AutoRoute(
              page: SessionsScreen,
              path: RoutePathsZodiac.chatsScreen,
              name: RoutePathsZodiac.chatsScreen),
          AutoRoute(
            page: AccountScreen,
            path: RoutePathsZodiac.accountScreen,
            name: RoutePathsZodiac.accountScreen,
          ),
          AutoRoute(
            page: ArticlesScreen,
            path: RoutePathsZodiac.articlesScreen,
            name: RoutePathsZodiac.articlesScreen,
          ),
        ]),
    AutoRoute(
      page: ArticleDetailsScreen,
      path: RoutePathsZodiac.articleDetailsScreen,
      name: RoutePathsZodiac.articleDetailsScreen,
    ),
    AutoRoute(
        page: EditProfileScreen,
        path: RoutePathsZodiac.profileScreen,
        name: RoutePathsZodiac.profileScreen),
    AutoRoute(
        page: GalleryPicturesScreen,
        path: RoutePathsZodiac.galleryScreen,
        name: RoutePathsZodiac.galleryScreen),
    AutoRoute(
      page: ForgotPasswordScreen,
      path: RoutePathsZodiac.forgotPasswordScreen,
      name: RoutePathsZodiac.forgotPasswordScreen,
    ),
    AutoRoute(
      page: NotificationsScreen,
      path: RoutePathsZodiac.notificationsScreen,
      name: RoutePathsZodiac.notificationsScreen,
    ),
    AutoRoute(
      page: ReviewsScreen,
      path: RoutePathsZodiac.reviewsScreen,
      name: RoutePathsZodiac.reviewsScreen,
    ),
    AutoRoute(
      page: BalanceAndTransactionsScreen,
      path: RoutePathsZodiac.balanceAndTransactionsScreen,
      name: RoutePathsZodiac.balanceAndTransactionsScreen,
    ),
    AutoRoute(
      page: SupportScreen,
      path: RoutePathsZodiac.supportScreen,
      name: RoutePathsZodiac.supportScreen,
    ),
    AutoRoute(
      page: SpecialitiesListScreen,
      path: RoutePathsZodiac.specialitiesListScreen,
      name: RoutePathsZodiac.specialitiesListScreen,
    ),
    AutoRoute(
      page: LocalesListScreen,
      path: RoutePathsZodiac.localesListScreen,
      name: RoutePathsZodiac.localesListScreen,
    ),
    AutoRoute(
      page: NotificationDetailsScreen,
      path: RoutePathsZodiac.notificationDetailsScreen,
      name: RoutePathsZodiac.notificationDetailsScreen,
    ),
    AutoRoute(
      page: ChatScreen,
      path: RoutePathsZodiac.chatScreen,
      name: RoutePathsZodiac.chatScreen,
    ),
    AutoRoute<ChatMessageModel?>(
      page: SendImageScreen,
      path: RoutePathsZodiac.sendImageScreen,
      name: RoutePathsZodiac.sendImageScreen,
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
