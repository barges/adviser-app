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
import 'package:auto_route/auto_route.dart' as _i20;
import 'package:flutter/material.dart' as _i21;
import 'package:shared_advisor_interface/presentation/screens/add_gallery_pictures/add_gallery_pictures_screen.dart'
    as _i5;
import 'package:shared_advisor_interface/presentation/screens/add_note/add_note_screen.dart'
    as _i6;
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/advisor_preview_screen.dart'
    as _i7;
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/balance_and_transactions_screen.dart'
    as _i8;
import 'package:shared_advisor_interface/presentation/screens/brand_screen/fortunica_brand_screen.dart'
    as _i1;
import 'package:shared_advisor_interface/presentation/screens/chat/chat_screen.dart'
    as _i9;
import 'package:shared_advisor_interface/presentation/screens/customer_profile/customer_profile_screen.dart'
    as _i10;
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/customer_sessions_screen.dart'
    as _i11;
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_screen.dart'
    as _i12;
import 'package:shared_advisor_interface/presentation/screens/force_update/force_update_screen.dart'
    as _i16;
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_screen.dart'
    as _i13;
import 'package:shared_advisor_interface/presentation/screens/gallery/gallery_pictures_screen.dart'
    as _i14;
import 'package:shared_advisor_interface/presentation/screens/home/home_screen.dart'
    as _i4;
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_screen.dart'
    as _i19;
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_screen.dart'
    as _i17;
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_screen.dart'
    as _i18;
import 'package:shared_advisor_interface/presentation/screens/home/tabs_types.dart'
    as _i22;
import 'package:shared_advisor_interface/presentation/screens/login/login_screen.dart'
    as _i3;
import 'package:shared_advisor_interface/presentation/screens/splash/splash_screen.dart'
    as _i2;
import 'package:shared_advisor_interface/presentation/screens/support/support_screen.dart'
    as _i15;

class MainAppRouter extends _i20.RootStackRouter {
  MainAppRouter([_i21.GlobalKey<_i21.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i20.PageFactory> pagesMap = {
    Fortunica.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.FortunicaBrandScreen(),
      );
    },
    FortunicaSplash.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.SplashScreen(),
      );
    },
    FortunicaLogin.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.LoginScreen(),
      );
    },
    FortunicaHome.name: (routeData) {
      final args = routeData.argsAs<FortunicaHomeArgs>(
          orElse: () => const FortunicaHomeArgs());
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.HomeScreen(
          key: args.key,
          initTab: args.initTab,
        ),
      );
    },
    FortunicaAddGalleryPictures.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.AddGalleryPicturesScreen(),
      );
    },
    FortunicaAddNote.name: (routeData) {
      final args = routeData.argsAs<FortunicaAddNoteArgs>();
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i6.AddNoteScreen(
          key: args.key,
          addNoteScreenArguments: args.addNoteScreenArguments,
        ),
      );
    },
    FortunicaAdvisorPreview.name: (routeData) {
      final args = routeData.argsAs<FortunicaAdvisorPreviewArgs>();
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i7.AdvisorPreviewScreen(
          key: args.key,
          isAccountTimeout: args.isAccountTimeout,
        ),
      );
    },
    FortunicaBalanceAndTransactions.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i8.BalanceAndTransactionsScreen(),
      );
    },
    FortunicaChat.name: (routeData) {
      final args = routeData.argsAs<FortunicaChatArgs>();
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i9.ChatScreen(
          key: args.key,
          chatScreenArguments: args.chatScreenArguments,
        ),
      );
    },
    FortunicaCustomerProfile.name: (routeData) {
      final args = routeData.argsAs<FortunicaCustomerProfileArgs>();
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i10.CustomerProfileScreen(
          key: args.key,
          customerProfileScreenArguments: args.customerProfileScreenArguments,
        ),
      );
    },
    FortunicaCustomerSessions.name: (routeData) {
      final args = routeData.argsAs<FortunicaCustomerSessionsArgs>();
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i11.CustomerSessionsScreen(
          key: args.key,
          customerSessionsScreenArguments: args.customerSessionsScreenArguments,
        ),
      );
    },
    FortunicaEditProfile.name: (routeData) {
      final args = routeData.argsAs<FortunicaEditProfileArgs>();
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i12.EditProfileScreen(
          key: args.key,
          isAccountTimeout: args.isAccountTimeout,
        ),
      );
    },
    FortunicaForgotPassword.name: (routeData) {
      final args = routeData.argsAs<FortunicaForgotPasswordArgs>(
          orElse: () => const FortunicaForgotPasswordArgs());
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i13.ForgotPasswordScreen(
          key: args.key,
          resetToken: args.resetToken,
        ),
      );
    },
    FortunicaGalleryPictures.name: (routeData) {
      final args = routeData.argsAs<FortunicaGalleryPicturesArgs>();
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i14.GalleryPicturesScreen(
          key: args.key,
          galleryPicturesScreenArguments: args.galleryPicturesScreenArguments,
        ),
      );
    },
    FortunicaSupport.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i15.SupportScreen(),
      );
    },
    ForceUpdate.name: (routeData) {
      final args = routeData.argsAs<ForceUpdateArgs>();
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i16.ForceUpdateScreen(
          key: args.key,
          forceUpdateScreenArguments: args.forceUpdateScreenArguments,
        ),
      );
    },
    FortunicaDashboard.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i17.DashboardV1Screen(),
      );
    },
    FortunicaChats.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i18.SessionsScreen(),
      );
    },
    FortunicaAccount.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i19.AccountScreen(),
      );
    },
  };

  @override
  List<_i20.RouteConfig> get routes => [
        _i20.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: 'fortunica',
          fullMatch: true,
        ),
        _i20.RouteConfig(
          Fortunica.name,
          path: 'fortunica',
          children: [
            _i20.RouteConfig(
              '#redirect',
              path: '',
              parent: Fortunica.name,
              redirectTo: 'fortunicaSplash',
              fullMatch: true,
            ),
            _i20.RouteConfig(
              FortunicaSplash.name,
              path: 'fortunicaSplash',
              parent: Fortunica.name,
            ),
            _i20.RouteConfig(
              FortunicaLogin.name,
              path: 'fortunicaLogin',
              parent: Fortunica.name,
            ),
            _i20.RouteConfig(
              FortunicaHome.name,
              path: 'fortunicaHome',
              parent: Fortunica.name,
              children: [
                _i20.RouteConfig(
                  FortunicaDashboard.name,
                  path: 'fortunicaDashboard',
                  parent: FortunicaHome.name,
                ),
                _i20.RouteConfig(
                  FortunicaChats.name,
                  path: 'fortunicaChats',
                  parent: FortunicaHome.name,
                ),
                _i20.RouteConfig(
                  FortunicaAccount.name,
                  path: 'fortunicaAccount',
                  parent: FortunicaHome.name,
                ),
              ],
            ),
            _i20.RouteConfig(
              FortunicaAddGalleryPictures.name,
              path: 'fortunicaAddGalleryPictures',
              parent: Fortunica.name,
            ),
            _i20.RouteConfig(
              FortunicaAddNote.name,
              path: 'fortunicaAddNote',
              parent: Fortunica.name,
            ),
            _i20.RouteConfig(
              FortunicaAdvisorPreview.name,
              path: 'fortunicaAdvisorPreview',
              parent: Fortunica.name,
            ),
            _i20.RouteConfig(
              FortunicaBalanceAndTransactions.name,
              path: 'fortunicaBalanceAndTransactions',
              parent: Fortunica.name,
            ),
            _i20.RouteConfig(
              FortunicaChat.name,
              path: 'fortunicaChat',
              parent: Fortunica.name,
            ),
            _i20.RouteConfig(
              FortunicaCustomerProfile.name,
              path: 'fortunicaCustomerProfile',
              parent: Fortunica.name,
            ),
            _i20.RouteConfig(
              FortunicaCustomerSessions.name,
              path: 'fortunicaCustomerSessions',
              parent: Fortunica.name,
            ),
            _i20.RouteConfig(
              FortunicaEditProfile.name,
              path: 'fortunicaEditProfile',
              parent: Fortunica.name,
            ),
            _i20.RouteConfig(
              FortunicaForgotPassword.name,
              path: 'fortunicaForgotPassword',
              parent: Fortunica.name,
            ),
            _i20.RouteConfig(
              FortunicaGalleryPictures.name,
              path: 'fortunicaGalleryPictures',
              parent: Fortunica.name,
            ),
            _i20.RouteConfig(
              FortunicaSupport.name,
              path: 'fortunicaSupport',
              parent: Fortunica.name,
            ),
            _i20.RouteConfig(
              ForceUpdate.name,
              path: 'ForceUpdate',
              parent: Fortunica.name,
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.FortunicaBrandScreen]
class Fortunica extends _i20.PageRouteInfo<void> {
  const Fortunica({List<_i20.PageRouteInfo>? children})
      : super(
          Fortunica.name,
          path: 'fortunica',
          initialChildren: children,
        );

  static const String name = 'Fortunica';
}

/// generated route for
/// [_i2.SplashScreen]
class FortunicaSplash extends _i20.PageRouteInfo<void> {
  const FortunicaSplash()
      : super(
          FortunicaSplash.name,
          path: 'fortunicaSplash',
        );

  static const String name = 'FortunicaSplash';
}

/// generated route for
/// [_i3.LoginScreen]
class FortunicaLogin extends _i20.PageRouteInfo<void> {
  const FortunicaLogin()
      : super(
          FortunicaLogin.name,
          path: 'fortunicaLogin',
        );

  static const String name = 'FortunicaLogin';
}

/// generated route for
/// [_i4.HomeScreen]
class FortunicaHome extends _i20.PageRouteInfo<FortunicaHomeArgs> {
  FortunicaHome({
    _i21.Key? key,
    _i22.TabsTypes? initTab,
    List<_i20.PageRouteInfo>? children,
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

  final _i21.Key? key;

  final _i22.TabsTypes? initTab;

  @override
  String toString() {
    return 'FortunicaHomeArgs{key: $key, initTab: $initTab}';
  }
}

/// generated route for
/// [_i5.AddGalleryPicturesScreen]
class FortunicaAddGalleryPictures extends _i20.PageRouteInfo<void> {
  const FortunicaAddGalleryPictures()
      : super(
          FortunicaAddGalleryPictures.name,
          path: 'fortunicaAddGalleryPictures',
        );

  static const String name = 'FortunicaAddGalleryPictures';
}

/// generated route for
/// [_i6.AddNoteScreen]
class FortunicaAddNote extends _i20.PageRouteInfo<FortunicaAddNoteArgs> {
  FortunicaAddNote({
    _i21.Key? key,
    required _i6.AddNoteScreenArguments addNoteScreenArguments,
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

  final _i21.Key? key;

  final _i6.AddNoteScreenArguments addNoteScreenArguments;

  @override
  String toString() {
    return 'FortunicaAddNoteArgs{key: $key, addNoteScreenArguments: $addNoteScreenArguments}';
  }
}

/// generated route for
/// [_i7.AdvisorPreviewScreen]
class FortunicaAdvisorPreview
    extends _i20.PageRouteInfo<FortunicaAdvisorPreviewArgs> {
  FortunicaAdvisorPreview({
    _i21.Key? key,
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

  final _i21.Key? key;

  final bool isAccountTimeout;

  @override
  String toString() {
    return 'FortunicaAdvisorPreviewArgs{key: $key, isAccountTimeout: $isAccountTimeout}';
  }
}

/// generated route for
/// [_i8.BalanceAndTransactionsScreen]
class FortunicaBalanceAndTransactions extends _i20.PageRouteInfo<void> {
  const FortunicaBalanceAndTransactions()
      : super(
          FortunicaBalanceAndTransactions.name,
          path: 'fortunicaBalanceAndTransactions',
        );

  static const String name = 'FortunicaBalanceAndTransactions';
}

/// generated route for
/// [_i9.ChatScreen]
class FortunicaChat extends _i20.PageRouteInfo<FortunicaChatArgs> {
  FortunicaChat({
    _i21.Key? key,
    required _i9.ChatScreenArguments chatScreenArguments,
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

  final _i21.Key? key;

  final _i9.ChatScreenArguments chatScreenArguments;

  @override
  String toString() {
    return 'FortunicaChatArgs{key: $key, chatScreenArguments: $chatScreenArguments}';
  }
}

/// generated route for
/// [_i10.CustomerProfileScreen]
class FortunicaCustomerProfile
    extends _i20.PageRouteInfo<FortunicaCustomerProfileArgs> {
  FortunicaCustomerProfile({
    _i21.Key? key,
    required _i10.CustomerProfileScreenArguments customerProfileScreenArguments,
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

  final _i21.Key? key;

  final _i10.CustomerProfileScreenArguments customerProfileScreenArguments;

  @override
  String toString() {
    return 'FortunicaCustomerProfileArgs{key: $key, customerProfileScreenArguments: $customerProfileScreenArguments}';
  }
}

/// generated route for
/// [_i11.CustomerSessionsScreen]
class FortunicaCustomerSessions
    extends _i20.PageRouteInfo<FortunicaCustomerSessionsArgs> {
  FortunicaCustomerSessions({
    _i21.Key? key,
    required _i11.CustomerSessionsScreenArguments
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

  final _i21.Key? key;

  final _i11.CustomerSessionsScreenArguments customerSessionsScreenArguments;

  @override
  String toString() {
    return 'FortunicaCustomerSessionsArgs{key: $key, customerSessionsScreenArguments: $customerSessionsScreenArguments}';
  }
}

/// generated route for
/// [_i12.EditProfileScreen]
class FortunicaEditProfile
    extends _i20.PageRouteInfo<FortunicaEditProfileArgs> {
  FortunicaEditProfile({
    _i21.Key? key,
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

  final _i21.Key? key;

  final bool isAccountTimeout;

  @override
  String toString() {
    return 'FortunicaEditProfileArgs{key: $key, isAccountTimeout: $isAccountTimeout}';
  }
}

/// generated route for
/// [_i13.ForgotPasswordScreen]
class FortunicaForgotPassword
    extends _i20.PageRouteInfo<FortunicaForgotPasswordArgs> {
  FortunicaForgotPassword({
    _i21.Key? key,
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

  final _i21.Key? key;

  final String? resetToken;

  @override
  String toString() {
    return 'FortunicaForgotPasswordArgs{key: $key, resetToken: $resetToken}';
  }
}

/// generated route for
/// [_i14.GalleryPicturesScreen]
class FortunicaGalleryPictures
    extends _i20.PageRouteInfo<FortunicaGalleryPicturesArgs> {
  FortunicaGalleryPictures({
    _i21.Key? key,
    required _i14.GalleryPicturesScreenArguments galleryPicturesScreenArguments,
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

  final _i21.Key? key;

  final _i14.GalleryPicturesScreenArguments galleryPicturesScreenArguments;

  @override
  String toString() {
    return 'FortunicaGalleryPicturesArgs{key: $key, galleryPicturesScreenArguments: $galleryPicturesScreenArguments}';
  }
}

/// generated route for
/// [_i15.SupportScreen]
class FortunicaSupport extends _i20.PageRouteInfo<void> {
  const FortunicaSupport()
      : super(
          FortunicaSupport.name,
          path: 'fortunicaSupport',
        );

  static const String name = 'FortunicaSupport';
}

/// generated route for
/// [_i16.ForceUpdateScreen]
class ForceUpdate extends _i20.PageRouteInfo<ForceUpdateArgs> {
  ForceUpdate({
    _i21.Key? key,
    required _i16.ForceUpdateScreenArguments forceUpdateScreenArguments,
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

  final _i21.Key? key;

  final _i16.ForceUpdateScreenArguments forceUpdateScreenArguments;

  @override
  String toString() {
    return 'ForceUpdateArgs{key: $key, forceUpdateScreenArguments: $forceUpdateScreenArguments}';
  }
}

/// generated route for
/// [_i17.DashboardV1Screen]
class FortunicaDashboard extends _i20.PageRouteInfo<void> {
  const FortunicaDashboard()
      : super(
          FortunicaDashboard.name,
          path: 'fortunicaDashboard',
        );

  static const String name = 'FortunicaDashboard';
}

/// generated route for
/// [_i18.SessionsScreen]
class FortunicaChats extends _i20.PageRouteInfo<void> {
  const FortunicaChats()
      : super(
          FortunicaChats.name,
          path: 'fortunicaChats',
        );

  static const String name = 'FortunicaChats';
}

/// generated route for
/// [_i19.AccountScreen]
class FortunicaAccount extends _i20.PageRouteInfo<void> {
  const FortunicaAccount()
      : super(
          FortunicaAccount.name,
          path: 'fortunicaAccount',
        );

  static const String name = 'FortunicaAccount';
}
