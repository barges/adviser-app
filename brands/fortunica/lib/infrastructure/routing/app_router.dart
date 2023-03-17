import 'package:shared_advisor_interface/configuration.dart';
import 'package:auto_route/annotations.dart';
import 'package:fortunica/infrastructure/routing/route_paths.dart';
import 'package:fortunica/presentation/screens/add_note/add_note_screen.dart';
import 'package:fortunica/presentation/screens/advisor_preview/advisor_preview_screen.dart';
import 'package:fortunica/presentation/screens/balance_and_transactions/balance_and_transactions_screen.dart';
import 'package:fortunica/presentation/screens/brand_screen/fortunica_brand_screen.dart';
import 'package:fortunica/presentation/screens/chat/chat_screen.dart';
import 'package:fortunica/presentation/screens/customer_profile/customer_profile_screen.dart';
import 'package:fortunica/presentation/screens/customer_sessions/customer_sessions_screen.dart';
import 'package:fortunica/presentation/screens/edit_profile/edit_profile_screen.dart';
import 'package:fortunica/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:fortunica/presentation/screens/gallery/gallery_pictures_screen.dart';
import 'package:fortunica/presentation/screens/home/home_screen.dart';
import 'package:fortunica/presentation/screens/home/tabs/account/account_screen.dart';
import 'package:fortunica/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_screen.dart';
import 'package:fortunica/presentation/screens/home/tabs/sessions/sessions_screen.dart';
import 'package:fortunica/presentation/screens/login/login_screen.dart';
import 'package:fortunica/presentation/screens/add_gallery_pictures/add_gallery_pictures_screen.dart';
import 'package:fortunica/presentation/screens/support/support_screen.dart';
import 'package:fortunica/presentation/wrappers/auth_wrapper/fortunica_auth_wrapper.dart';

const fortunicaRoute = AutoRoute(
  page: FortunicaBrandScreen,
  path: Brand.fortunicaAlias,
  name: Brand.fortunicaAlias,
  children: <AutoRoute>[
    AutoRoute(
        page: FortunicaAuthWrapper,
        path: '',
        initial: true,
        name: RoutePaths.authScreen,
        children: [
          AutoRoute(
            page: LoginScreen,
            path: RoutePaths.loginScreen,
            name: RoutePaths.loginScreen,
            initial: true,
          ),
        ]),
    AutoRoute(
        page: HomeScreen,
        path: RoutePaths.homeScreen,
        name: RoutePaths.homeScreen,
        children: [
          AutoRoute(
              page: DashboardV1Screen,
              path: RoutePaths.dashboardScreen,
              name: RoutePaths.dashboardScreen,),
          AutoRoute(
              page: SessionsScreen,
              path: RoutePaths.chatsScreen,
              name: RoutePaths.chatsScreen),
          AutoRoute(
              page: AccountScreen,
              path: RoutePaths.accountScreen,
              name: RoutePaths.accountScreen),
        ]),
    AutoRoute(
      page: AddGalleryPicturesScreen,
      path: RoutePaths.addGalleryPicturesScreen,
      name: RoutePaths.addGalleryPicturesScreen,
    ),
    AutoRoute(
      page: AddNoteScreen,
      path: RoutePaths.addNoteScreen,
      name: RoutePaths.addNoteScreen,
    ),
    AutoRoute(
      page: AdvisorPreviewScreen,
      path: RoutePaths.advisorPreviewScreen,
      name: RoutePaths.advisorPreviewScreen,
    ),
    AutoRoute(
      page: BalanceAndTransactionsScreen,
      path: RoutePaths.balanceAndTransactionsScreen,
      name: RoutePaths.balanceAndTransactionsScreen,
    ),
    AutoRoute(
      page: ChatScreen,
      path: RoutePaths.chatScreen,
      name: RoutePaths.chatScreen,
    ),
    AutoRoute(
      page: CustomerProfileScreen,
      path: RoutePaths.customerProfileScreen,
      name: RoutePaths.customerProfileScreen,
    ),
    AutoRoute(
      page: CustomerSessionsScreen,
      path: RoutePaths.customerSessionsScreen,
      name: RoutePaths.customerSessionsScreen,
    ),
    AutoRoute(
      page: EditProfileScreen,
      path: RoutePaths.editProfileScreen,
      name: RoutePaths.editProfileScreen,
    ),
    AutoRoute(
      page: ForgotPasswordScreen,
      path: RoutePaths.forgotPasswordScreen,
      name: RoutePaths.forgotPasswordScreen,
    ),
    AutoRoute(
      page: GalleryPicturesScreen,
      path: RoutePaths.galleryPicturesScreen,
      name: RoutePaths.galleryPicturesScreen,
    ),
    AutoRoute(
      page: SupportScreen,
      path: RoutePaths.supportScreen,
      name: RoutePaths.supportScreen,
    ),
  ],
);

///Will hold all the routes in our app
// @AdaptiveAutoRouter(
//   replaceInRouteName: 'Page|Dialog|Screen,Route',
//   routes: <AutoRoute>[
//     AutoRoute(
//       page: FortunicaBrandScreen,
//       path: Brand.fortunicaAlias,
//       name: Brand.fortunicaAlias,
//       children: <AutoRoute>[
//         AutoRoute(
//             initial: true,
//             page: MainWrapper,
//             path: '',
//             name: '${Brand.fortunicaAlias}${RoutePaths.mainScreen}',
//             children: [
//               AutoRoute(
//                   initial: true,
//                   page: HomeScreen,
//                   path: RoutePaths.homeScreen,
//                   name: '${Brand.fortunicaAlias}${RoutePaths.homeScreen}',
//                   children: [
//                     AutoRoute(
//                         page: DashboardScreen,
//                         path: RoutePaths.dashboardScreen,
//                         name:
//                             '${Brand.fortunicaAlias}${RoutePaths.dashboardScreen}'),
//                     AutoRoute(
//                         page: ChatsScreen,
//                         path: RoutePaths.chatsScreen,
//                         name:
//                             '${Brand.fortunicaAlias}${RoutePaths.chatsScreen}'),
//                     AutoRoute(
//                         page: AccountScreen,
//                         path: RoutePaths.accountScreen,
//                         name:
//                             '${Brand.fortunicaAlias}${RoutePaths.accountScreen}'),
//                     AutoRoute(
//                         page: ArticlesScreen,
//                         path: RoutePaths.articlesScreen,
//                         name:
//                             '${Brand.fortunicaAlias}${RoutePaths.articlesScreen}'),
//                   ]),
//             ]),
//         AutoRoute(
//             page: AuthWrapper,
//             path: RoutePaths.authScreen,
//             name: '${Brand.fortunicaAlias}${RoutePaths.authScreen}',
//             children: [
//               AutoRoute(
//                 page: LoginScreen,
//                 path: RoutePaths.authScreen,
//                 name: '${Brand.fortunicaAlias}${RoutePaths.loginScreen}',
//                 initial: true,
//               ),
//             ]),
//       ],
//     )
//   ],
// )
// // extend the generated private router
// class $FortunicaAppRouter {}
