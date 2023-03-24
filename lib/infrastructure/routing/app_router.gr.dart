// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i36;
import 'package:flutter/material.dart' as _i37;
import 'package:fortunica/presentation/screens/add_gallery_pictures/add_gallery_pictures_screen.dart'
    as _i8;
import 'package:fortunica/presentation/screens/add_note/add_note_screen.dart'
    as _i9;
import 'package:fortunica/presentation/screens/advisor_preview/advisor_preview_screen.dart'
    as _i10;
import 'package:fortunica/presentation/screens/balance_and_transactions/balance_and_transactions_screen.dart'
    as _i11;
import 'package:fortunica/presentation/screens/brand_screen/fortunica_brand_screen.dart'
    as _i4;
import 'package:fortunica/presentation/screens/chat/chat_screen.dart' as _i12;
import 'package:fortunica/presentation/screens/customer_profile/customer_profile_screen.dart'
    as _i13;
import 'package:fortunica/presentation/screens/customer_sessions/customer_sessions_screen.dart'
    as _i14;
import 'package:fortunica/presentation/screens/edit_profile/edit_profile_screen.dart'
    as _i15;
import 'package:fortunica/presentation/screens/forgot_password/forgot_password_screen.dart'
    as _i16;
import 'package:fortunica/presentation/screens/gallery/gallery_pictures_screen.dart'
    as _i17;
import 'package:fortunica/presentation/screens/home/home_screen.dart' as _i7;
import 'package:fortunica/presentation/screens/home/tabs/account/account_screen.dart'
    as _i22;
import 'package:fortunica/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_screen.dart'
    as _i20;
import 'package:fortunica/presentation/screens/home/tabs/sessions/sessions_screen.dart'
    as _i21;
import 'package:fortunica/presentation/screens/home/tabs_types.dart' as _i38;
import 'package:fortunica/presentation/screens/login/login_screen.dart' as _i19;
import 'package:fortunica/presentation/screens/support/support_screen.dart'
    as _i18;
import 'package:fortunica/presentation/wrappers/auth_wrapper/fortunica_auth_wrapper.dart'
    as _i6;
import 'package:shared_advisor_interface/presentation/screens/all_brands/all_brands_screen.dart'
    as _i3;
import 'package:shared_advisor_interface/presentation/screens/force_update/force_update_screen.dart'
    as _i2;
import 'package:shared_advisor_interface/presentation/screens/home_screen/main_home_screen.dart'
    as _i1;
import 'package:zodiac/presentation/screens/article_detail_screen/article_detail_screen.dart'
    as _i25;
import 'package:zodiac/presentation/screens/brand_screen/zodiac_brand_screen.dart'
    as _i5;
import 'package:zodiac/presentation/screens/forgot_password/forgot_password_screen.dart'
    as _i28;
import 'package:zodiac/presentation/screens/gallery/gallery_pictures_screen.dart'
    as _i27;
import 'package:zodiac/presentation/screens/home/home_screen.dart' as _i24;
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_screen.dart'
    as _i34;
import 'package:zodiac/presentation/screens/home/tabs/articles/articles_screen.dart'
    as _i35;
import 'package:zodiac/presentation/screens/home/tabs/dashboard/dashboard_screen.dart'
    as _i32;
import 'package:zodiac/presentation/screens/home/tabs/sessions/sessions_screen.dart'
    as _i33;
import 'package:zodiac/presentation/screens/home/tabs_types.dart' as _i39;
import 'package:zodiac/presentation/screens/login/login_screen.dart' as _i31;
import 'package:zodiac/presentation/screens/notifications/notifications_screen.dart'
    as _i29;
import 'package:zodiac/presentation/screens/profile/profile.dart' as _i26;
import 'package:zodiac/presentation/screens/reviews/reviews_screen.dart'
    as _i30;
import 'package:zodiac/presentation/wrappers/auth_wrapper/zodiac_auth_wrapper.dart'
    as _i23;

class MainAppRouter extends _i36.RootStackRouter {
  MainAppRouter([_i37.GlobalKey<_i37.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i36.PageFactory> pagesMap = {
    MainHomeScreen.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.MainHomeScreen(),
      );
    },
    ForceUpdate.name: (routeData) {
      final args = routeData.argsAs<ForceUpdateArgs>();
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i2.ForceUpdateScreen(
          key: args.key,
          forceUpdateScreenArguments: args.forceUpdateScreenArguments,
        ),
      );
    },
    AllBrands.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.AllBrandsScreen(),
      );
    },
    Fortunica.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.FortunicaBrandScreen(),
      );
    },
    Zodiac.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.ZodiacBrandScreen(),
      );
    },
    FortunicaAuth.name: (routeData) {
      final args = routeData.argsAs<FortunicaAuthArgs>(
          orElse: () => const FortunicaAuthArgs());
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i6.FortunicaAuthWrapper(
          key: args.key,
          initTab: args.initTab,
        ),
      );
    },
    FortunicaHome.name: (routeData) {
      final args = routeData.argsAs<FortunicaHomeArgs>(
          orElse: () => const FortunicaHomeArgs());
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i7.HomeScreen(
          key: args.key,
          initTab: args.initTab,
        ),
      );
    },
    FortunicaAddGalleryPictures.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i8.AddGalleryPicturesScreen(),
      );
    },
    FortunicaAddNote.name: (routeData) {
      final args = routeData.argsAs<FortunicaAddNoteArgs>();
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i9.AddNoteScreen(
          key: args.key,
          addNoteScreenArguments: args.addNoteScreenArguments,
        ),
      );
    },
    FortunicaAdvisorPreview.name: (routeData) {
      final args = routeData.argsAs<FortunicaAdvisorPreviewArgs>();
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i10.AdvisorPreviewScreen(
          key: args.key,
          isAccountTimeout: args.isAccountTimeout,
        ),
      );
    },
    FortunicaBalanceAndTransactions.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i11.BalanceAndTransactionsScreen(),
      );
    },
    FortunicaChat.name: (routeData) {
      final args = routeData.argsAs<FortunicaChatArgs>();
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i12.ChatScreen(
          key: args.key,
          chatScreenArguments: args.chatScreenArguments,
        ),
      );
    },
    FortunicaCustomerProfile.name: (routeData) {
      final args = routeData.argsAs<FortunicaCustomerProfileArgs>();
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i13.CustomerProfileScreen(
          key: args.key,
          customerProfileScreenArguments: args.customerProfileScreenArguments,
        ),
      );
    },
    FortunicaCustomerSessions.name: (routeData) {
      final args = routeData.argsAs<FortunicaCustomerSessionsArgs>();
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i14.CustomerSessionsScreen(
          key: args.key,
          customerSessionsScreenArguments: args.customerSessionsScreenArguments,
        ),
      );
    },
    FortunicaEditProfile.name: (routeData) {
      final args = routeData.argsAs<FortunicaEditProfileArgs>();
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i15.EditProfileScreen(
          key: args.key,
          isAccountTimeout: args.isAccountTimeout,
        ),
      );
    },
    FortunicaForgotPassword.name: (routeData) {
      final args = routeData.argsAs<FortunicaForgotPasswordArgs>(
          orElse: () => const FortunicaForgotPasswordArgs());
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i16.ForgotPasswordScreen(
          key: args.key,
          resetToken: args.resetToken,
        ),
      );
    },
    FortunicaGalleryPictures.name: (routeData) {
      final args = routeData.argsAs<FortunicaGalleryPicturesArgs>();
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i17.GalleryPicturesScreen(
          key: args.key,
          galleryPicturesScreenArguments: args.galleryPicturesScreenArguments,
        ),
      );
    },
    FortunicaSupport.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i18.SupportScreen(),
      );
    },
    FortunicaLogin.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i19.LoginScreen(),
      );
    },
    FortunicaDashboard.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i20.DashboardV1Screen(),
      );
    },
    FortunicaChats.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i21.SessionsScreen(),
      );
    },
    FortunicaAccount.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i22.AccountScreen(),
      );
    },
    ZodiacAuth.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i23.ZodiacAuthWrapper(),
      );
    },
    ZodiacHome.name: (routeData) {
      final args = routeData.argsAs<ZodiacHomeArgs>(
          orElse: () => const ZodiacHomeArgs());
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i24.HomeScreen(
          key: args.key,
          initTab: args.initTab,
        ),
      );
    },
    ZodiacArticleDetail.name: (routeData) {
      final args = routeData.argsAs<ZodiacArticleDetailArgs>();
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i25.ArticleDetailScreen(
          key: args.key,
          articleId: args.articleId,
        ),
      );
    },
    ZodiacProfile.name: (routeData) {
      final args = routeData.argsAs<ZodiacProfileArgs>();
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i26.ProfileScreen(
          key: args.key,
          name: args.name,
        ),
      );
    },
    ZodiacGalleryPictures.name: (routeData) {
      final args = routeData.argsAs<ZodiacGalleryPicturesArgs>();
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i27.GalleryPicturesScreen(
          key: args.key,
          galleryPicturesScreenArguments: args.galleryPicturesScreenArguments,
        ),
      );
    },
    ZodiacForgotPassword.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i28.ForgotPasswordScreen(),
      );
    },
    ZodiacNotifications.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i29.NotificationsScreen(),
      );
    },
    ZodiacReviews.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i30.ReviewsScreen(),
      );
    },
    ZodiacLogin.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i31.LoginScreen(),
      );
    },
    ZodiacDashboard.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i32.DashboardScreen(),
      );
    },
    ZodiacChats.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i33.SessionsScreen(),
      );
    },
    ZodiacAccount.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i34.AccountScreen(),
      );
    },
    ZodiacArticles.name: (routeData) {
      return _i36.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i35.ArticlesScreen(),
      );
    },
  };

  @override
  List<_i36.RouteConfig> get routes => [
        _i36.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/home',
          fullMatch: true,
        ),
        _i36.RouteConfig(
          MainHomeScreen.name,
          path: '/home',
          children: [
            _i36.RouteConfig(
              Fortunica.name,
              path: 'fortunica',
              parent: MainHomeScreen.name,
              children: [
                _i36.RouteConfig(
                  '#redirect',
                  path: '',
                  parent: Fortunica.name,
                  redirectTo: 'fortunicaAuth',
                  fullMatch: true,
                ),
                _i36.RouteConfig(
                  FortunicaAuth.name,
                  path: 'fortunicaAuth',
                  parent: Fortunica.name,
                  children: [
                    _i36.RouteConfig(
                      '#redirect',
                      path: '',
                      parent: FortunicaAuth.name,
                      redirectTo: 'fortunicaLogin',
                      fullMatch: true,
                    ),
                    _i36.RouteConfig(
                      FortunicaLogin.name,
                      path: 'fortunicaLogin',
                      parent: FortunicaAuth.name,
                    ),
                  ],
                ),
                _i36.RouteConfig(
                  FortunicaHome.name,
                  path: 'fortunicaHome',
                  parent: Fortunica.name,
                  children: [
                    _i36.RouteConfig(
                      FortunicaDashboard.name,
                      path: 'fortunicaDashboard',
                      parent: FortunicaHome.name,
                    ),
                    _i36.RouteConfig(
                      FortunicaChats.name,
                      path: 'fortunicaChats',
                      parent: FortunicaHome.name,
                    ),
                    _i36.RouteConfig(
                      FortunicaAccount.name,
                      path: 'fortunicaAccount',
                      parent: FortunicaHome.name,
                    ),
                  ],
                ),
                _i36.RouteConfig(
                  FortunicaAddGalleryPictures.name,
                  path: 'fortunicaAddGalleryPictures',
                  parent: Fortunica.name,
                ),
                _i36.RouteConfig(
                  FortunicaAddNote.name,
                  path: 'fortunicaAddNote',
                  parent: Fortunica.name,
                ),
                _i36.RouteConfig(
                  FortunicaAdvisorPreview.name,
                  path: 'fortunicaAdvisorPreview',
                  parent: Fortunica.name,
                ),
                _i36.RouteConfig(
                  FortunicaBalanceAndTransactions.name,
                  path: 'fortunicaBalanceAndTransactions',
                  parent: Fortunica.name,
                ),
                _i36.RouteConfig(
                  FortunicaChat.name,
                  path: 'fortunicaChat',
                  parent: Fortunica.name,
                ),
                _i36.RouteConfig(
                  FortunicaCustomerProfile.name,
                  path: 'fortunicaCustomerProfile',
                  parent: Fortunica.name,
                ),
                _i36.RouteConfig(
                  FortunicaCustomerSessions.name,
                  path: 'fortunicaCustomerSessions',
                  parent: Fortunica.name,
                ),
                _i36.RouteConfig(
                  FortunicaEditProfile.name,
                  path: 'fortunicaEditProfile',
                  parent: Fortunica.name,
                ),
                _i36.RouteConfig(
                  FortunicaForgotPassword.name,
                  path: 'fortunicaForgotPassword',
                  parent: Fortunica.name,
                ),
                _i36.RouteConfig(
                  FortunicaGalleryPictures.name,
                  path: 'fortunicaGalleryPictures',
                  parent: Fortunica.name,
                ),
                _i36.RouteConfig(
                  FortunicaSupport.name,
                  path: 'fortunicaSupport',
                  parent: Fortunica.name,
                ),
              ],
            ),
            _i36.RouteConfig(
              Zodiac.name,
              path: 'zodiac',
              parent: MainHomeScreen.name,
              children: [
                _i36.RouteConfig(
                  '#redirect',
                  path: '',
                  parent: Zodiac.name,
                  redirectTo: 'zodiacAuth',
                  fullMatch: true,
                ),
                _i36.RouteConfig(
                  ZodiacAuth.name,
                  path: 'zodiacAuth',
                  parent: Zodiac.name,
                  children: [
                    _i36.RouteConfig(
                      '#redirect',
                      path: '',
                      parent: ZodiacAuth.name,
                      redirectTo: 'zodiacLogin',
                      fullMatch: true,
                    ),
                    _i36.RouteConfig(
                      ZodiacLogin.name,
                      path: 'zodiacLogin',
                      parent: ZodiacAuth.name,
                    ),
                  ],
                ),
                _i36.RouteConfig(
                  ZodiacHome.name,
                  path: 'zodiacHome',
                  parent: Zodiac.name,
                  children: [
                    _i36.RouteConfig(
                      ZodiacDashboard.name,
                      path: 'zodiacDashboard',
                      parent: ZodiacHome.name,
                    ),
                    _i36.RouteConfig(
                      ZodiacChats.name,
                      path: 'zodiacChats',
                      parent: ZodiacHome.name,
                    ),
                    _i36.RouteConfig(
                      ZodiacAccount.name,
                      path: 'zodiacAccount',
                      parent: ZodiacHome.name,
                    ),
                    _i36.RouteConfig(
                      ZodiacArticles.name,
                      path: 'zodiacArticles',
                      parent: ZodiacHome.name,
                    ),
                  ],
                ),
                _i36.RouteConfig(
                  ZodiacArticleDetail.name,
                  path: 'zodiacArticleDetail',
                  parent: Zodiac.name,
                ),
                _i36.RouteConfig(
                  ZodiacProfile.name,
                  path: 'zodiacProfile',
                  parent: Zodiac.name,
                ),
                _i36.RouteConfig(
                  ZodiacGalleryPictures.name,
                  path: 'zodiacGalleryPictures',
                  parent: Zodiac.name,
                ),
                _i36.RouteConfig(
                  ZodiacForgotPassword.name,
                  path: 'zodiacForgotPassword',
                  parent: Zodiac.name,
                ),
                _i36.RouteConfig(
                  ZodiacNotifications.name,
                  path: 'zodiacNotifications',
                  parent: Zodiac.name,
                ),
                _i36.RouteConfig(
                  ZodiacReviews.name,
                  path: 'zodiacReviews',
                  parent: Zodiac.name,
                ),
              ],
            ),
          ],
        ),
        _i36.RouteConfig(
          ForceUpdate.name,
          path: 'ForceUpdate',
        ),
        _i36.RouteConfig(
          AllBrands.name,
          path: 'AllBrands',
        ),
      ];
}

/// generated route for
/// [_i1.MainHomeScreen]
class MainHomeScreen extends _i36.PageRouteInfo<void> {
  const MainHomeScreen({List<_i36.PageRouteInfo>? children})
      : super(
          MainHomeScreen.name,
          path: '/home',
          initialChildren: children,
        );

  static const String name = 'MainHomeScreen';
}

/// generated route for
/// [_i2.ForceUpdateScreen]
class ForceUpdate extends _i36.PageRouteInfo<ForceUpdateArgs> {
  ForceUpdate({
    _i37.Key? key,
    required _i2.ForceUpdateScreenArguments forceUpdateScreenArguments,
  }) : super(
          ForceUpdate.name,
          path: 'ForceUpdate',
          args: ForceUpdateArgs(
            key: key,
            forceUpdateScreenArguments: forceUpdateScreenArguments,
          ),
        );

  static const String name = 'ForceUpdate';
}

class ForceUpdateArgs {
  const ForceUpdateArgs({
    this.key,
    required this.forceUpdateScreenArguments,
  });

  final _i37.Key? key;

  final _i2.ForceUpdateScreenArguments forceUpdateScreenArguments;

  @override
  String toString() {
    return 'ForceUpdateArgs{key: $key, forceUpdateScreenArguments: $forceUpdateScreenArguments}';
  }
}

/// generated route for
/// [_i3.AllBrandsScreen]
class AllBrands extends _i36.PageRouteInfo<void> {
  const AllBrands()
      : super(
          AllBrands.name,
          path: 'AllBrands',
        );

  static const String name = 'AllBrands';
}

/// generated route for
/// [_i4.FortunicaBrandScreen]
class Fortunica extends _i36.PageRouteInfo<void> {
  const Fortunica({List<_i36.PageRouteInfo>? children})
      : super(
          Fortunica.name,
          path: 'fortunica',
          initialChildren: children,
        );

  static const String name = 'Fortunica';
}

/// generated route for
/// [_i5.ZodiacBrandScreen]
class Zodiac extends _i36.PageRouteInfo<void> {
  const Zodiac({List<_i36.PageRouteInfo>? children})
      : super(
          Zodiac.name,
          path: 'zodiac',
          initialChildren: children,
        );

  static const String name = 'Zodiac';
}

/// generated route for
/// [_i6.FortunicaAuthWrapper]
class FortunicaAuth extends _i36.PageRouteInfo<FortunicaAuthArgs> {
  FortunicaAuth({
    _i37.Key? key,
    _i38.TabsTypes? initTab,
    List<_i36.PageRouteInfo>? children,
  }) : super(
          FortunicaAuth.name,
          path: 'fortunicaAuth',
          args: FortunicaAuthArgs(
            key: key,
            initTab: initTab,
          ),
          initialChildren: children,
        );

  static const String name = 'FortunicaAuth';
}

class FortunicaAuthArgs {
  const FortunicaAuthArgs({
    this.key,
    this.initTab,
  });

  final _i37.Key? key;

  final _i38.TabsTypes? initTab;

  @override
  String toString() {
    return 'FortunicaAuthArgs{key: $key, initTab: $initTab}';
  }
}

/// generated route for
/// [_i7.HomeScreen]
class FortunicaHome extends _i36.PageRouteInfo<FortunicaHomeArgs> {
  FortunicaHome({
    _i37.Key? key,
    _i38.TabsTypes? initTab,
    List<_i36.PageRouteInfo>? children,
  }) : super(
          FortunicaHome.name,
          path: 'fortunicaHome',
          args: FortunicaHomeArgs(
            key: key,
            initTab: initTab,
          ),
          initialChildren: children,
        );

  static const String name = 'FortunicaHome';
}

class FortunicaHomeArgs {
  const FortunicaHomeArgs({
    this.key,
    this.initTab,
  });

  final _i37.Key? key;

  final _i38.TabsTypes? initTab;

  @override
  String toString() {
    return 'FortunicaHomeArgs{key: $key, initTab: $initTab}';
  }
}

/// generated route for
/// [_i8.AddGalleryPicturesScreen]
class FortunicaAddGalleryPictures extends _i36.PageRouteInfo<void> {
  const FortunicaAddGalleryPictures()
      : super(
          FortunicaAddGalleryPictures.name,
          path: 'fortunicaAddGalleryPictures',
        );

  static const String name = 'FortunicaAddGalleryPictures';
}

/// generated route for
/// [_i9.AddNoteScreen]
class FortunicaAddNote extends _i36.PageRouteInfo<FortunicaAddNoteArgs> {
  FortunicaAddNote({
    _i37.Key? key,
    required _i9.AddNoteScreenArguments addNoteScreenArguments,
  }) : super(
          FortunicaAddNote.name,
          path: 'fortunicaAddNote',
          args: FortunicaAddNoteArgs(
            key: key,
            addNoteScreenArguments: addNoteScreenArguments,
          ),
        );

  static const String name = 'FortunicaAddNote';
}

class FortunicaAddNoteArgs {
  const FortunicaAddNoteArgs({
    this.key,
    required this.addNoteScreenArguments,
  });

  final _i37.Key? key;

  final _i9.AddNoteScreenArguments addNoteScreenArguments;

  @override
  String toString() {
    return 'FortunicaAddNoteArgs{key: $key, addNoteScreenArguments: $addNoteScreenArguments}';
  }
}

/// generated route for
/// [_i10.AdvisorPreviewScreen]
class FortunicaAdvisorPreview
    extends _i36.PageRouteInfo<FortunicaAdvisorPreviewArgs> {
  FortunicaAdvisorPreview({
    _i37.Key? key,
    required bool isAccountTimeout,
  }) : super(
          FortunicaAdvisorPreview.name,
          path: 'fortunicaAdvisorPreview',
          args: FortunicaAdvisorPreviewArgs(
            key: key,
            isAccountTimeout: isAccountTimeout,
          ),
        );

  static const String name = 'FortunicaAdvisorPreview';
}

class FortunicaAdvisorPreviewArgs {
  const FortunicaAdvisorPreviewArgs({
    this.key,
    required this.isAccountTimeout,
  });

  final _i37.Key? key;

  final bool isAccountTimeout;

  @override
  String toString() {
    return 'FortunicaAdvisorPreviewArgs{key: $key, isAccountTimeout: $isAccountTimeout}';
  }
}

/// generated route for
/// [_i11.BalanceAndTransactionsScreen]
class FortunicaBalanceAndTransactions extends _i36.PageRouteInfo<void> {
  const FortunicaBalanceAndTransactions()
      : super(
          FortunicaBalanceAndTransactions.name,
          path: 'fortunicaBalanceAndTransactions',
        );

  static const String name = 'FortunicaBalanceAndTransactions';
}

/// generated route for
/// [_i12.ChatScreen]
class FortunicaChat extends _i36.PageRouteInfo<FortunicaChatArgs> {
  FortunicaChat({
    _i37.Key? key,
    required _i12.ChatScreenArguments chatScreenArguments,
  }) : super(
          FortunicaChat.name,
          path: 'fortunicaChat',
          args: FortunicaChatArgs(
            key: key,
            chatScreenArguments: chatScreenArguments,
          ),
        );

  static const String name = 'FortunicaChat';
}

class FortunicaChatArgs {
  const FortunicaChatArgs({
    this.key,
    required this.chatScreenArguments,
  });

  final _i37.Key? key;

  final _i12.ChatScreenArguments chatScreenArguments;

  @override
  String toString() {
    return 'FortunicaChatArgs{key: $key, chatScreenArguments: $chatScreenArguments}';
  }
}

/// generated route for
/// [_i13.CustomerProfileScreen]
class FortunicaCustomerProfile
    extends _i36.PageRouteInfo<FortunicaCustomerProfileArgs> {
  FortunicaCustomerProfile({
    _i37.Key? key,
    required _i13.CustomerProfileScreenArguments customerProfileScreenArguments,
  }) : super(
          FortunicaCustomerProfile.name,
          path: 'fortunicaCustomerProfile',
          args: FortunicaCustomerProfileArgs(
            key: key,
            customerProfileScreenArguments: customerProfileScreenArguments,
          ),
        );

  static const String name = 'FortunicaCustomerProfile';
}

class FortunicaCustomerProfileArgs {
  const FortunicaCustomerProfileArgs({
    this.key,
    required this.customerProfileScreenArguments,
  });

  final _i37.Key? key;

  final _i13.CustomerProfileScreenArguments customerProfileScreenArguments;

  @override
  String toString() {
    return 'FortunicaCustomerProfileArgs{key: $key, customerProfileScreenArguments: $customerProfileScreenArguments}';
  }
}

/// generated route for
/// [_i14.CustomerSessionsScreen]
class FortunicaCustomerSessions
    extends _i36.PageRouteInfo<FortunicaCustomerSessionsArgs> {
  FortunicaCustomerSessions({
    _i37.Key? key,
    required _i14.CustomerSessionsScreenArguments
        customerSessionsScreenArguments,
  }) : super(
          FortunicaCustomerSessions.name,
          path: 'fortunicaCustomerSessions',
          args: FortunicaCustomerSessionsArgs(
            key: key,
            customerSessionsScreenArguments: customerSessionsScreenArguments,
          ),
        );

  static const String name = 'FortunicaCustomerSessions';
}

class FortunicaCustomerSessionsArgs {
  const FortunicaCustomerSessionsArgs({
    this.key,
    required this.customerSessionsScreenArguments,
  });

  final _i37.Key? key;

  final _i14.CustomerSessionsScreenArguments customerSessionsScreenArguments;

  @override
  String toString() {
    return 'FortunicaCustomerSessionsArgs{key: $key, customerSessionsScreenArguments: $customerSessionsScreenArguments}';
  }
}

/// generated route for
/// [_i15.EditProfileScreen]
class FortunicaEditProfile
    extends _i36.PageRouteInfo<FortunicaEditProfileArgs> {
  FortunicaEditProfile({
    _i37.Key? key,
    required bool isAccountTimeout,
  }) : super(
          FortunicaEditProfile.name,
          path: 'fortunicaEditProfile',
          args: FortunicaEditProfileArgs(
            key: key,
            isAccountTimeout: isAccountTimeout,
          ),
        );

  static const String name = 'FortunicaEditProfile';
}

class FortunicaEditProfileArgs {
  const FortunicaEditProfileArgs({
    this.key,
    required this.isAccountTimeout,
  });

  final _i37.Key? key;

  final bool isAccountTimeout;

  @override
  String toString() {
    return 'FortunicaEditProfileArgs{key: $key, isAccountTimeout: $isAccountTimeout}';
  }
}

/// generated route for
/// [_i16.ForgotPasswordScreen]
class FortunicaForgotPassword
    extends _i36.PageRouteInfo<FortunicaForgotPasswordArgs> {
  FortunicaForgotPassword({
    _i37.Key? key,
    String? resetToken,
  }) : super(
          FortunicaForgotPassword.name,
          path: 'fortunicaForgotPassword',
          args: FortunicaForgotPasswordArgs(
            key: key,
            resetToken: resetToken,
          ),
        );

  static const String name = 'FortunicaForgotPassword';
}

class FortunicaForgotPasswordArgs {
  const FortunicaForgotPasswordArgs({
    this.key,
    this.resetToken,
  });

  final _i37.Key? key;

  final String? resetToken;

  @override
  String toString() {
    return 'FortunicaForgotPasswordArgs{key: $key, resetToken: $resetToken}';
  }
}

/// generated route for
/// [_i17.GalleryPicturesScreen]
class FortunicaGalleryPictures
    extends _i36.PageRouteInfo<FortunicaGalleryPicturesArgs> {
  FortunicaGalleryPictures({
    _i37.Key? key,
    required _i17.GalleryPicturesScreenArguments galleryPicturesScreenArguments,
  }) : super(
          FortunicaGalleryPictures.name,
          path: 'fortunicaGalleryPictures',
          args: FortunicaGalleryPicturesArgs(
            key: key,
            galleryPicturesScreenArguments: galleryPicturesScreenArguments,
          ),
        );

  static const String name = 'FortunicaGalleryPictures';
}

class FortunicaGalleryPicturesArgs {
  const FortunicaGalleryPicturesArgs({
    this.key,
    required this.galleryPicturesScreenArguments,
  });

  final _i37.Key? key;

  final _i17.GalleryPicturesScreenArguments galleryPicturesScreenArguments;

  @override
  String toString() {
    return 'FortunicaGalleryPicturesArgs{key: $key, galleryPicturesScreenArguments: $galleryPicturesScreenArguments}';
  }
}

/// generated route for
/// [_i18.SupportScreen]
class FortunicaSupport extends _i36.PageRouteInfo<void> {
  const FortunicaSupport()
      : super(
          FortunicaSupport.name,
          path: 'fortunicaSupport',
        );

  static const String name = 'FortunicaSupport';
}

/// generated route for
/// [_i19.LoginScreen]
class FortunicaLogin extends _i36.PageRouteInfo<void> {
  const FortunicaLogin()
      : super(
          FortunicaLogin.name,
          path: 'fortunicaLogin',
        );

  static const String name = 'FortunicaLogin';
}

/// generated route for
/// [_i20.DashboardV1Screen]
class FortunicaDashboard extends _i36.PageRouteInfo<void> {
  const FortunicaDashboard()
      : super(
          FortunicaDashboard.name,
          path: 'fortunicaDashboard',
        );

  static const String name = 'FortunicaDashboard';
}

/// generated route for
/// [_i21.SessionsScreen]
class FortunicaChats extends _i36.PageRouteInfo<void> {
  const FortunicaChats()
      : super(
          FortunicaChats.name,
          path: 'fortunicaChats',
        );

  static const String name = 'FortunicaChats';
}

/// generated route for
/// [_i22.AccountScreen]
class FortunicaAccount extends _i36.PageRouteInfo<void> {
  const FortunicaAccount()
      : super(
          FortunicaAccount.name,
          path: 'fortunicaAccount',
        );

  static const String name = 'FortunicaAccount';
}

/// generated route for
/// [_i23.ZodiacAuthWrapper]
class ZodiacAuth extends _i36.PageRouteInfo<void> {
  const ZodiacAuth({List<_i36.PageRouteInfo>? children})
      : super(
          ZodiacAuth.name,
          path: 'zodiacAuth',
          initialChildren: children,
        );

  static const String name = 'ZodiacAuth';
}

/// generated route for
/// [_i24.HomeScreen]
class ZodiacHome extends _i36.PageRouteInfo<ZodiacHomeArgs> {
  ZodiacHome({
    _i37.Key? key,
    _i39.TabsTypes? initTab,
    List<_i36.PageRouteInfo>? children,
  }) : super(
          ZodiacHome.name,
          path: 'zodiacHome',
          args: ZodiacHomeArgs(
            key: key,
            initTab: initTab,
          ),
          initialChildren: children,
        );

  static const String name = 'ZodiacHome';
}

class ZodiacHomeArgs {
  const ZodiacHomeArgs({
    this.key,
    this.initTab,
  });

  final _i37.Key? key;

  final _i39.TabsTypes? initTab;

  @override
  String toString() {
    return 'ZodiacHomeArgs{key: $key, initTab: $initTab}';
  }
}

/// generated route for
/// [_i25.ArticleDetailScreen]
class ZodiacArticleDetail extends _i36.PageRouteInfo<ZodiacArticleDetailArgs> {
  ZodiacArticleDetail({
    _i37.Key? key,
    required int articleId,
  }) : super(
          ZodiacArticleDetail.name,
          path: 'zodiacArticleDetail',
          args: ZodiacArticleDetailArgs(
            key: key,
            articleId: articleId,
          ),
        );

  static const String name = 'ZodiacArticleDetail';
}

class ZodiacArticleDetailArgs {
  const ZodiacArticleDetailArgs({
    this.key,
    required this.articleId,
  });

  final _i37.Key? key;

  final int articleId;

  @override
  String toString() {
    return 'ZodiacArticleDetailArgs{key: $key, articleId: $articleId}';
  }
}

/// generated route for
/// [_i26.ProfileScreen]
class ZodiacProfile extends _i36.PageRouteInfo<ZodiacProfileArgs> {
  ZodiacProfile({
    _i37.Key? key,
    required String name,
  }) : super(
          ZodiacProfile.name,
          path: 'zodiacProfile',
          args: ZodiacProfileArgs(
            key: key,
            name: name,
          ),
        );

  static const String name = 'ZodiacProfile';
}

class ZodiacProfileArgs {
  const ZodiacProfileArgs({
    this.key,
    required this.name,
  });

  final _i37.Key? key;

  final String name;

  @override
  String toString() {
    return 'ZodiacProfileArgs{key: $key, name: $name}';
  }
}

/// generated route for
/// [_i27.GalleryPicturesScreen]
class ZodiacGalleryPictures
    extends _i36.PageRouteInfo<ZodiacGalleryPicturesArgs> {
  ZodiacGalleryPictures({
    _i37.Key? key,
    required _i27.GalleryPicturesScreenArguments galleryPicturesScreenArguments,
  }) : super(
          ZodiacGalleryPictures.name,
          path: 'zodiacGalleryPictures',
          args: ZodiacGalleryPicturesArgs(
            key: key,
            galleryPicturesScreenArguments: galleryPicturesScreenArguments,
          ),
        );

  static const String name = 'ZodiacGalleryPictures';
}

class ZodiacGalleryPicturesArgs {
  const ZodiacGalleryPicturesArgs({
    this.key,
    required this.galleryPicturesScreenArguments,
  });

  final _i37.Key? key;

  final _i27.GalleryPicturesScreenArguments galleryPicturesScreenArguments;

  @override
  String toString() {
    return 'ZodiacGalleryPicturesArgs{key: $key, galleryPicturesScreenArguments: $galleryPicturesScreenArguments}';
  }
}

/// generated route for
/// [_i28.ForgotPasswordScreen]
class ZodiacForgotPassword extends _i36.PageRouteInfo<void> {
  const ZodiacForgotPassword()
      : super(
          ZodiacForgotPassword.name,
          path: 'zodiacForgotPassword',
        );

  static const String name = 'ZodiacForgotPassword';
}

/// generated route for
/// [_i29.NotificationsScreen]
class ZodiacNotifications extends _i36.PageRouteInfo<void> {
  const ZodiacNotifications()
      : super(
          ZodiacNotifications.name,
          path: 'zodiacNotifications',
        );

  static const String name = 'ZodiacNotifications';
}

/// generated route for
/// [_i30.ReviewsScreen]
class ZodiacReviews extends _i36.PageRouteInfo<void> {
  const ZodiacReviews()
      : super(
          ZodiacReviews.name,
          path: 'zodiacReviews',
        );

  static const String name = 'ZodiacReviews';
}

/// generated route for
/// [_i31.LoginScreen]
class ZodiacLogin extends _i36.PageRouteInfo<void> {
  const ZodiacLogin()
      : super(
          ZodiacLogin.name,
          path: 'zodiacLogin',
        );

  static const String name = 'ZodiacLogin';
}

/// generated route for
/// [_i32.DashboardScreen]
class ZodiacDashboard extends _i36.PageRouteInfo<void> {
  const ZodiacDashboard()
      : super(
          ZodiacDashboard.name,
          path: 'zodiacDashboard',
        );

  static const String name = 'ZodiacDashboard';
}

/// generated route for
/// [_i33.SessionsScreen]
class ZodiacChats extends _i36.PageRouteInfo<void> {
  const ZodiacChats()
      : super(
          ZodiacChats.name,
          path: 'zodiacChats',
        );

  static const String name = 'ZodiacChats';
}

/// generated route for
/// [_i34.AccountScreen]
class ZodiacAccount extends _i36.PageRouteInfo<void> {
  const ZodiacAccount()
      : super(
          ZodiacAccount.name,
          path: 'zodiacAccount',
        );

  static const String name = 'ZodiacAccount';
}

/// generated route for
/// [_i35.ArticlesScreen]
class ZodiacArticles extends _i36.PageRouteInfo<void> {
  const ZodiacArticles()
      : super(
          ZodiacArticles.name,
          path: 'zodiacArticles',
        );

  static const String name = 'ZodiacArticles';
}
