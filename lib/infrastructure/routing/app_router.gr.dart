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
import 'dart:io' as _i61;

import 'package:auto_route/auto_route.dart' as _i54;
import 'package:flutter/material.dart' as _i55;
import 'package:fortunica/presentation/screens/add_gallery_pictures/add_gallery_pictures_screen.dart'
    as _i7;
import 'package:fortunica/presentation/screens/add_note/add_note_screen.dart'
    as _i8;
import 'package:fortunica/presentation/screens/advisor_preview/advisor_preview_screen.dart'
    as _i9;
import 'package:fortunica/presentation/screens/balance_and_transactions/balance_and_transactions_screen.dart'
    as _i10;
import 'package:fortunica/presentation/screens/brand_screen/fortunica_brand_screen.dart'
    as _i3;
import 'package:fortunica/presentation/screens/chat/chat_screen.dart' as _i11;
import 'package:fortunica/presentation/screens/customer_profile/customer_profile_screen.dart'
    as _i12;
import 'package:fortunica/presentation/screens/customer_sessions/customer_sessions_screen.dart'
    as _i13;
import 'package:fortunica/presentation/screens/edit_profile/edit_profile_screen.dart'
    as _i14;
import 'package:fortunica/presentation/screens/forgot_password/forgot_password_screen.dart'
    as _i15;
import 'package:fortunica/presentation/screens/gallery/gallery_pictures_screen.dart'
    as _i16;
import 'package:fortunica/presentation/screens/home/home_screen.dart' as _i6;
import 'package:fortunica/presentation/screens/home/tabs/account/account_screen.dart'
    as _i21;
import 'package:fortunica/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_screen.dart'
    as _i19;
import 'package:fortunica/presentation/screens/home/tabs/sessions/sessions_screen.dart'
    as _i20;
import 'package:fortunica/presentation/screens/home/tabs_types.dart' as _i56;
import 'package:fortunica/presentation/screens/login/login_screen.dart' as _i18;
import 'package:fortunica/presentation/screens/support/support_screen.dart'
    as _i17;
import 'package:fortunica/presentation/wrappers/auth_wrapper/fortunica_auth_wrapper.dart'
    as _i5;
import 'package:shared_advisor_interface/presentation/screens/force_update/force_update_screen.dart'
    as _i2;
import 'package:shared_advisor_interface/presentation/screens/home_screen/main_home_screen.dart'
    as _i1;
import 'package:zodiac/data/models/chat/user_data.dart' as _i60;
import 'package:zodiac/data/models/services/service_item.dart' as _i62;
import 'package:zodiac/data/models/settings/phone.dart' as _i59;
import 'package:zodiac/data/models/user_info/category_info.dart' as _i63;
import 'package:zodiac/data/models/user_info/user_balance.dart' as _i58;
import 'package:zodiac/presentation/screens/add_service/add_service_screen.dart'
    as _i41;
import 'package:zodiac/presentation/screens/article_details_screen/article_details_screen.dart'
    as _i24;
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_screen.dart'
    as _i48;
import 'package:zodiac/presentation/screens/balance_and_transactions/balance_and_transactions_screen.dart'
    as _i30;
import 'package:zodiac/presentation/screens/brand_screen/zodiac_brand_screen.dart'
    as _i4;
import 'package:zodiac/presentation/screens/canned_messages/canned_messages_screen.dart'
    as _i33;
import 'package:zodiac/presentation/screens/categories_methods_list/categories_methods_list_screen.dart'
    as _i46;
import 'package:zodiac/presentation/screens/chat/chat_screen.dart' as _i39;
import 'package:zodiac/presentation/screens/complete_service/complete_service_screen.dart'
    as _i44;
import 'package:zodiac/presentation/screens/duplicate_service/duplicate_service_screen.dart'
    as _i42;
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_screen.dart'
    as _i25;
import 'package:zodiac/presentation/screens/edit_service/edit_service_screen.dart'
    as _i43;
import 'package:zodiac/presentation/screens/forgot_password/forgot_password_screen.dart'
    as _i27;
import 'package:zodiac/presentation/screens/gallery/gallery_pictures_screen.dart'
    as _i26;
import 'package:zodiac/presentation/screens/home/home_screen.dart' as _i23;
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_screen.dart'
    as _i52;
import 'package:zodiac/presentation/screens/home/tabs/articles/articles_screen.dart'
    as _i53;
import 'package:zodiac/presentation/screens/home/tabs/dashboard/dashboard_screen.dart'
    as _i50;
import 'package:zodiac/presentation/screens/home/tabs/sessions/sessions_screen.dart'
    as _i51;
import 'package:zodiac/presentation/screens/home/tabs_types.dart' as _i57;
import 'package:zodiac/presentation/screens/locales_list/locales_list_screen.dart'
    as _i37;
import 'package:zodiac/presentation/screens/login/login_screen.dart' as _i49;
import 'package:zodiac/presentation/screens/notification_details/notification_details_screen.dart'
    as _i38;
import 'package:zodiac/presentation/screens/notifications/notifications_screen.dart'
    as _i28;
import 'package:zodiac/presentation/screens/phone_number/phone_number_screen.dart'
    as _i31;
import 'package:zodiac/presentation/screens/reviews/reviews_screen.dart'
    as _i29;
import 'package:zodiac/presentation/screens/select_categories/select_categories_screen.dart'
    as _i45;
import 'package:zodiac/presentation/screens/select_methods/select_methods_screen.dart'
    as _i47;
import 'package:zodiac/presentation/screens/send_image/send_image_screen.dart'
    as _i40;
import 'package:zodiac/presentation/screens/services/services_screen.dart'
    as _i32;
import 'package:zodiac/presentation/screens/sms_verification/sms_verification_screen.dart'
    as _i34;
import 'package:zodiac/presentation/screens/sms_verification/widgets/phone_number_verified_screen.dart'
    as _i35;
import 'package:zodiac/presentation/screens/support/support_screen.dart'
    as _i36;
import 'package:zodiac/presentation/wrappers/auth_wrapper/zodiac_auth_wrapper.dart'
    as _i22;

class MainAppRouter extends _i54.RootStackRouter {
  MainAppRouter([_i55.GlobalKey<_i55.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i54.PageFactory> pagesMap = {
    MainHomeScreen.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.MainHomeScreen(),
      );
    },
    ForceUpdate.name: (routeData) {
      final args = routeData.argsAs<ForceUpdateArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i2.ForceUpdateScreen(
          key: args.key,
          forceUpdateScreenArguments: args.forceUpdateScreenArguments,
        ),
      );
    },
    Fortunica.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.FortunicaBrandScreen(),
      );
    },
    Zodiac.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.ZodiacBrandScreen(),
      );
    },
    FortunicaAuth.name: (routeData) {
      final args = routeData.argsAs<FortunicaAuthArgs>(
          orElse: () => const FortunicaAuthArgs());
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i5.FortunicaAuthWrapper(
          key: args.key,
          initTab: args.initTab,
        ),
      );
    },
    FortunicaHome.name: (routeData) {
      final args = routeData.argsAs<FortunicaHomeArgs>(
          orElse: () => const FortunicaHomeArgs());
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i6.HomeScreen(
          key: args.key,
          initTab: args.initTab,
        ),
      );
    },
    FortunicaAddGalleryPictures.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.AddGalleryPicturesScreen(),
      );
    },
    FortunicaAddNote.name: (routeData) {
      final args = routeData.argsAs<FortunicaAddNoteArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i8.AddNoteScreen(
          key: args.key,
          addNoteScreenArguments: args.addNoteScreenArguments,
        ),
      );
    },
    FortunicaAdvisorPreview.name: (routeData) {
      final args = routeData.argsAs<FortunicaAdvisorPreviewArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i9.AdvisorPreviewScreen(
          key: args.key,
          isAccountTimeout: args.isAccountTimeout,
        ),
      );
    },
    FortunicaBalanceAndTransactions.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i10.BalanceAndTransactionsScreen(),
      );
    },
    FortunicaChat.name: (routeData) {
      final args = routeData.argsAs<FortunicaChatArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i11.ChatScreen(
          key: args.key,
          chatScreenArguments: args.chatScreenArguments,
        ),
      );
    },
    FortunicaCustomerProfile.name: (routeData) {
      final args = routeData.argsAs<FortunicaCustomerProfileArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i12.CustomerProfileScreen(
          key: args.key,
          customerProfileScreenArguments: args.customerProfileScreenArguments,
        ),
      );
    },
    FortunicaCustomerSessions.name: (routeData) {
      final args = routeData.argsAs<FortunicaCustomerSessionsArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i13.CustomerSessionsScreen(
          key: args.key,
          customerSessionsScreenArguments: args.customerSessionsScreenArguments,
        ),
      );
    },
    FortunicaEditProfile.name: (routeData) {
      final args = routeData.argsAs<FortunicaEditProfileArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i14.EditProfileScreen(
          key: args.key,
          isAccountTimeout: args.isAccountTimeout,
        ),
      );
    },
    FortunicaForgotPassword.name: (routeData) {
      final args = routeData.argsAs<FortunicaForgotPasswordArgs>(
          orElse: () => const FortunicaForgotPasswordArgs());
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i15.ForgotPasswordScreen(
          key: args.key,
          resetToken: args.resetToken,
        ),
      );
    },
    FortunicaGalleryPictures.name: (routeData) {
      final args = routeData.argsAs<FortunicaGalleryPicturesArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i16.GalleryPicturesScreen(
          key: args.key,
          galleryPicturesScreenArguments: args.galleryPicturesScreenArguments,
        ),
      );
    },
    FortunicaSupport.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i17.SupportScreen(),
      );
    },
    FortunicaLogin.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i18.LoginScreen(),
      );
    },
    FortunicaDashboard.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i19.DashboardV1Screen(),
      );
    },
    FortunicaChats.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i20.SessionsScreen(),
      );
    },
    FortunicaAccount.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i21.AccountScreen(),
      );
    },
    ZodiacAuth.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i22.ZodiacAuthWrapper(),
      );
    },
    ZodiacHome.name: (routeData) {
      final args = routeData.argsAs<ZodiacHomeArgs>(
          orElse: () => const ZodiacHomeArgs());
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i23.HomeScreen(
          key: args.key,
          initTab: args.initTab,
        ),
      );
    },
    ZodiacArticleDetails.name: (routeData) {
      final args = routeData.argsAs<ZodiacArticleDetailsArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i24.ArticleDetailsScreen(
          key: args.key,
          articleId: args.articleId,
        ),
      );
    },
    ZodiacEditProfile.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i25.EditProfileScreen(),
      );
    },
    ZodiacGalleryPictures.name: (routeData) {
      final args = routeData.argsAs<ZodiacGalleryPicturesArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i26.GalleryPicturesScreen(
          key: args.key,
          galleryPicturesScreenArguments: args.galleryPicturesScreenArguments,
        ),
      );
    },
    ZodiacForgotPassword.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i27.ForgotPasswordScreen(),
      );
    },
    ZodiacNotifications.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i28.NotificationsScreen(),
      );
    },
    ZodiacReviews.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i29.ReviewsScreen(),
      );
    },
    ZodiacBalanceAndTransactions.name: (routeData) {
      final args = routeData.argsAs<ZodiacBalanceAndTransactionsArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i30.BalanceAndTransactionsScreen(
          key: args.key,
          userBalance: args.userBalance,
        ),
      );
    },
    ZodiacPhoneNumber.name: (routeData) {
      final args = routeData.argsAs<ZodiacPhoneNumberArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i31.PhoneNumberScreen(
          key: args.key,
          siteKey: args.siteKey,
          phone: args.phone,
        ),
      );
    },
    ZodiacServices.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i32.ServicesScreen(),
      );
    },
    ZodiacCannedMessages.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i33.CannedMessagesScreen(),
      );
    },
    ZodiacSMSVerification.name: (routeData) {
      final args = routeData.argsAs<ZodiacSMSVerificationArgs>(
          orElse: () => const ZodiacSMSVerificationArgs());
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i34.SMSVerificationScreen(
          key: args.key,
          phoneNumber: args.phoneNumber,
        ),
      );
    },
    ZodiacPhoneNumberVerified.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i35.PhoneNumberVerifiedScreen(),
      );
    },
    ZodiacSupport.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i36.SupportScreen(),
      );
    },
    ZodiacLocalesList.name: (routeData) {
      final args = routeData.argsAs<ZodiacLocalesListArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i37.LocalesListScreen(
          key: args.key,
          returnCallback: args.returnCallback,
          title: args.title,
          oldSelectedLocaleCode: args.oldSelectedLocaleCode,
          unnecessaryLocalesCodes: args.unnecessaryLocalesCodes,
        ),
      );
    },
    ZodiacNotificationDetails.name: (routeData) {
      final args = routeData.argsAs<ZodiacNotificationDetailsArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i38.NotificationDetailsScreen(
          key: args.key,
          pushId: args.pushId,
          needRefreshList: args.needRefreshList,
        ),
      );
    },
    ZodiacChat.name: (routeData) {
      final args = routeData.argsAs<ZodiacChatArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i39.ChatScreen(
          key: args.key,
          userData: args.userData,
          fromStartingChat: args.fromStartingChat,
        ),
      );
    },
    ZodiacSendImage.name: (routeData) {
      final args = routeData.argsAs<ZodiacSendImageArgs>();
      return _i54.AdaptivePage<bool?>(
        routeData: routeData,
        child: _i40.SendImageScreen(
          key: args.key,
          image: args.image,
        ),
      );
    },
    ZodiacAddService.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i41.AddServiceScreen(),
      );
    },
    ZodiacDuplicateService.name: (routeData) {
      final args = routeData.argsAs<ZodiacDuplicateServiceArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i42.DuplicateServiceScreen(
          key: args.key,
          returnCallback: args.returnCallback,
          approvedServices: args.approvedServices,
          oldDuplicatedServiceId: args.oldDuplicatedServiceId,
        ),
      );
    },
    ZodiacEditService.name: (routeData) {
      final args = routeData.argsAs<ZodiacEditServiceArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i43.EditServiceScreen(
          key: args.key,
          serviceId: args.serviceId,
        ),
      );
    },
    ZodiacCompleteService.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i44.CompleteServiceScreen(),
      );
    },
    ZodiacSelectCategories.name: (routeData) {
      final args = routeData.argsAs<ZodiacSelectCategoriesArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i45.SelectCategoriesScreen(
          key: args.key,
          selectedCategoryIds: args.selectedCategoryIds,
          returnCallback: args.returnCallback,
          mainCategoryId: args.mainCategoryId,
        ),
      );
    },
    ZodiacCategoriesMethodsList.name: (routeData) {
      final args = routeData.argsAs<ZodiacCategoriesMethodsListArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i46.CategoriesMethodsListScreen(
          key: args.key,
          title: args.title,
          items: args.items,
          returnCallback: args.returnCallback,
          initialSelectedId: args.initialSelectedId,
        ),
      );
    },
    ZodiacSelectMethods.name: (routeData) {
      final args = routeData.argsAs<ZodiacSelectMethodsArgs>();
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i47.SelectMethodsScreen(
          key: args.key,
          selectedMethodIds: args.selectedMethodIds,
          returnCallback: args.returnCallback,
          mainMethodId: args.mainMethodId,
        ),
      );
    },
    ZodiacAutoReply.name: (routeData) {
      return _i54.AdaptivePage<bool?>(
        routeData: routeData,
        child: const _i48.AutoReplyScreen(),
      );
    },
    ZodiacLogin.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i49.LoginScreen(),
      );
    },
    ZodiacDashboard.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i50.DashboardScreen(),
      );
    },
    ZodiacChats.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i51.SessionsScreen(),
      );
    },
    ZodiacAccount.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i52.AccountScreen(),
      );
    },
    ZodiacArticles.name: (routeData) {
      return _i54.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i53.ArticlesScreen(),
      );
    },
  };

  @override
  List<_i54.RouteConfig> get routes => [
        _i54.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/home',
          fullMatch: true,
        ),
        _i54.RouteConfig(
          MainHomeScreen.name,
          path: '/home',
          children: [
            _i54.RouteConfig(
              Fortunica.name,
              path: 'fortunica',
              parent: MainHomeScreen.name,
              children: [
                _i54.RouteConfig(
                  '#redirect',
                  path: '',
                  parent: Fortunica.name,
                  redirectTo: 'fortunicaAuth',
                  fullMatch: true,
                ),
                _i54.RouteConfig(
                  FortunicaAuth.name,
                  path: 'fortunicaAuth',
                  parent: Fortunica.name,
                  children: [
                    _i54.RouteConfig(
                      '#redirect',
                      path: '',
                      parent: FortunicaAuth.name,
                      redirectTo: 'fortunicaLogin',
                      fullMatch: true,
                    ),
                    _i54.RouteConfig(
                      FortunicaLogin.name,
                      path: 'fortunicaLogin',
                      parent: FortunicaAuth.name,
                    ),
                  ],
                ),
                _i54.RouteConfig(
                  FortunicaHome.name,
                  path: 'fortunicaHome',
                  parent: Fortunica.name,
                  children: [
                    _i54.RouteConfig(
                      FortunicaDashboard.name,
                      path: 'fortunicaDashboard',
                      parent: FortunicaHome.name,
                    ),
                    _i54.RouteConfig(
                      FortunicaChats.name,
                      path: 'fortunicaChats',
                      parent: FortunicaHome.name,
                    ),
                    _i54.RouteConfig(
                      FortunicaAccount.name,
                      path: 'fortunicaAccount',
                      parent: FortunicaHome.name,
                    ),
                  ],
                ),
                _i54.RouteConfig(
                  FortunicaAddGalleryPictures.name,
                  path: 'fortunicaAddGalleryPictures',
                  parent: Fortunica.name,
                ),
                _i54.RouteConfig(
                  FortunicaAddNote.name,
                  path: 'fortunicaAddNote',
                  parent: Fortunica.name,
                ),
                _i54.RouteConfig(
                  FortunicaAdvisorPreview.name,
                  path: 'fortunicaAdvisorPreview',
                  parent: Fortunica.name,
                ),
                _i54.RouteConfig(
                  FortunicaBalanceAndTransactions.name,
                  path: 'fortunicaBalanceAndTransactions',
                  parent: Fortunica.name,
                ),
                _i54.RouteConfig(
                  FortunicaChat.name,
                  path: 'fortunicaChat',
                  parent: Fortunica.name,
                ),
                _i54.RouteConfig(
                  FortunicaCustomerProfile.name,
                  path: 'fortunicaCustomerProfile',
                  parent: Fortunica.name,
                ),
                _i54.RouteConfig(
                  FortunicaCustomerSessions.name,
                  path: 'fortunicaCustomerSessions',
                  parent: Fortunica.name,
                ),
                _i54.RouteConfig(
                  FortunicaEditProfile.name,
                  path: 'fortunicaEditProfile',
                  parent: Fortunica.name,
                ),
                _i54.RouteConfig(
                  FortunicaForgotPassword.name,
                  path: 'fortunicaForgotPassword',
                  parent: Fortunica.name,
                ),
                _i54.RouteConfig(
                  FortunicaGalleryPictures.name,
                  path: 'fortunicaGalleryPictures',
                  parent: Fortunica.name,
                ),
                _i54.RouteConfig(
                  FortunicaSupport.name,
                  path: 'fortunicaSupport',
                  parent: Fortunica.name,
                ),
              ],
            ),
            _i54.RouteConfig(
              Zodiac.name,
              path: 'zodiac',
              parent: MainHomeScreen.name,
              children: [
                _i54.RouteConfig(
                  '#redirect',
                  path: '',
                  parent: Zodiac.name,
                  redirectTo: 'zodiacAuth',
                  fullMatch: true,
                ),
                _i54.RouteConfig(
                  ZodiacAuth.name,
                  path: 'zodiacAuth',
                  parent: Zodiac.name,
                  children: [
                    _i54.RouteConfig(
                      '#redirect',
                      path: '',
                      parent: ZodiacAuth.name,
                      redirectTo: 'zodiacLogin',
                      fullMatch: true,
                    ),
                    _i54.RouteConfig(
                      ZodiacLogin.name,
                      path: 'zodiacLogin',
                      parent: ZodiacAuth.name,
                    ),
                  ],
                ),
                _i54.RouteConfig(
                  ZodiacHome.name,
                  path: 'zodiacHome',
                  parent: Zodiac.name,
                  children: [
                    _i54.RouteConfig(
                      ZodiacDashboard.name,
                      path: 'zodiacDashboard',
                      parent: ZodiacHome.name,
                    ),
                    _i54.RouteConfig(
                      ZodiacChats.name,
                      path: 'zodiacChats',
                      parent: ZodiacHome.name,
                    ),
                    _i54.RouteConfig(
                      ZodiacAccount.name,
                      path: 'zodiacAccount',
                      parent: ZodiacHome.name,
                    ),
                    _i54.RouteConfig(
                      ZodiacArticles.name,
                      path: 'zodiacArticles',
                      parent: ZodiacHome.name,
                    ),
                  ],
                ),
                _i54.RouteConfig(
                  ZodiacArticleDetails.name,
                  path: 'zodiacArticleDetails',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacEditProfile.name,
                  path: 'zodiacEditProfile',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacGalleryPictures.name,
                  path: 'zodiacGalleryPictures',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacForgotPassword.name,
                  path: 'zodiacForgotPassword',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacNotifications.name,
                  path: 'zodiacNotifications',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacReviews.name,
                  path: 'zodiacReviews',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacBalanceAndTransactions.name,
                  path: 'zodiacBalanceAndTransactions',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacPhoneNumber.name,
                  path: 'zodiacPhoneNumber',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacServices.name,
                  path: 'zodiacServices',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacCannedMessages.name,
                  path: 'zodiacCannedMessages',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacSMSVerification.name,
                  path: 'zodiacSMSVerification',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacPhoneNumberVerified.name,
                  path: 'zodiacPhoneNumberVerified',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacSupport.name,
                  path: 'zodiacSupport',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacLocalesList.name,
                  path: 'zodiacLocalesList',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacNotificationDetails.name,
                  path: 'zodiacNotificationDetails',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacChat.name,
                  path: 'zodiacChat',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacSendImage.name,
                  path: 'zodiacSendImage',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacAddService.name,
                  path: 'zodiacAddService',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacDuplicateService.name,
                  path: 'zodiacDuplicateService',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacEditService.name,
                  path: 'zodiacEditService',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacCompleteService.name,
                  path: 'zodiacCompleteService',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacSelectCategories.name,
                  path: 'zodiacSelectCategories',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacCategoriesMethodsList.name,
                  path: 'zodiacCategoriesMethodsList',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacSelectMethods.name,
                  path: 'zodiacSelectMethods',
                  parent: Zodiac.name,
                ),
                _i54.RouteConfig(
                  ZodiacAutoReply.name,
                  path: 'zodiacAutoReply',
                  parent: Zodiac.name,
                ),
              ],
            ),
          ],
        ),
        _i54.RouteConfig(
          ForceUpdate.name,
          path: 'ForceUpdate',
        ),
      ];
}

/// generated route for
/// [_i1.MainHomeScreen]
class MainHomeScreen extends _i54.PageRouteInfo<void> {
  const MainHomeScreen({List<_i54.PageRouteInfo>? children})
      : super(
          MainHomeScreen.name,
          path: '/home',
          initialChildren: children,
        );

  static const String name = 'MainHomeScreen';
}

/// generated route for
/// [_i2.ForceUpdateScreen]
class ForceUpdate extends _i54.PageRouteInfo<ForceUpdateArgs> {
  ForceUpdate({
    _i55.Key? key,
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

  final _i55.Key? key;

  final _i2.ForceUpdateScreenArguments forceUpdateScreenArguments;

  @override
  String toString() {
    return 'ForceUpdateArgs{key: $key, forceUpdateScreenArguments: $forceUpdateScreenArguments}';
  }
}

/// generated route for
/// [_i3.FortunicaBrandScreen]
class Fortunica extends _i54.PageRouteInfo<void> {
  const Fortunica({List<_i54.PageRouteInfo>? children})
      : super(
          Fortunica.name,
          path: 'fortunica',
          initialChildren: children,
        );

  static const String name = 'Fortunica';
}

/// generated route for
/// [_i4.ZodiacBrandScreen]
class Zodiac extends _i54.PageRouteInfo<void> {
  const Zodiac({List<_i54.PageRouteInfo>? children})
      : super(
          Zodiac.name,
          path: 'zodiac',
          initialChildren: children,
        );

  static const String name = 'Zodiac';
}

/// generated route for
/// [_i5.FortunicaAuthWrapper]
class FortunicaAuth extends _i54.PageRouteInfo<FortunicaAuthArgs> {
  FortunicaAuth({
    _i55.Key? key,
    _i56.TabsTypes? initTab,
    List<_i54.PageRouteInfo>? children,
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

  final _i55.Key? key;

  final _i56.TabsTypes? initTab;

  @override
  String toString() {
    return 'FortunicaAuthArgs{key: $key, initTab: $initTab}';
  }
}

/// generated route for
/// [_i6.HomeScreen]
class FortunicaHome extends _i54.PageRouteInfo<FortunicaHomeArgs> {
  FortunicaHome({
    _i55.Key? key,
    _i56.TabsTypes? initTab,
    List<_i54.PageRouteInfo>? children,
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

  final _i55.Key? key;

  final _i56.TabsTypes? initTab;

  @override
  String toString() {
    return 'FortunicaHomeArgs{key: $key, initTab: $initTab}';
  }
}

/// generated route for
/// [_i7.AddGalleryPicturesScreen]
class FortunicaAddGalleryPictures extends _i54.PageRouteInfo<void> {
  const FortunicaAddGalleryPictures()
      : super(
          FortunicaAddGalleryPictures.name,
          path: 'fortunicaAddGalleryPictures',
        );

  static const String name = 'FortunicaAddGalleryPictures';
}

/// generated route for
/// [_i8.AddNoteScreen]
class FortunicaAddNote extends _i54.PageRouteInfo<FortunicaAddNoteArgs> {
  FortunicaAddNote({
    _i55.Key? key,
    required _i8.AddNoteScreenArguments addNoteScreenArguments,
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

  final _i55.Key? key;

  final _i8.AddNoteScreenArguments addNoteScreenArguments;

  @override
  String toString() {
    return 'FortunicaAddNoteArgs{key: $key, addNoteScreenArguments: $addNoteScreenArguments}';
  }
}

/// generated route for
/// [_i9.AdvisorPreviewScreen]
class FortunicaAdvisorPreview
    extends _i54.PageRouteInfo<FortunicaAdvisorPreviewArgs> {
  FortunicaAdvisorPreview({
    _i55.Key? key,
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

  final _i55.Key? key;

  final bool isAccountTimeout;

  @override
  String toString() {
    return 'FortunicaAdvisorPreviewArgs{key: $key, isAccountTimeout: $isAccountTimeout}';
  }
}

/// generated route for
/// [_i10.BalanceAndTransactionsScreen]
class FortunicaBalanceAndTransactions extends _i54.PageRouteInfo<void> {
  const FortunicaBalanceAndTransactions()
      : super(
          FortunicaBalanceAndTransactions.name,
          path: 'fortunicaBalanceAndTransactions',
        );

  static const String name = 'FortunicaBalanceAndTransactions';
}

/// generated route for
/// [_i11.ChatScreen]
class FortunicaChat extends _i54.PageRouteInfo<FortunicaChatArgs> {
  FortunicaChat({
    _i55.Key? key,
    required _i11.ChatScreenArguments chatScreenArguments,
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

  final _i55.Key? key;

  final _i11.ChatScreenArguments chatScreenArguments;

  @override
  String toString() {
    return 'FortunicaChatArgs{key: $key, chatScreenArguments: $chatScreenArguments}';
  }
}

/// generated route for
/// [_i12.CustomerProfileScreen]
class FortunicaCustomerProfile
    extends _i54.PageRouteInfo<FortunicaCustomerProfileArgs> {
  FortunicaCustomerProfile({
    _i55.Key? key,
    required _i12.CustomerProfileScreenArguments customerProfileScreenArguments,
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

  final _i55.Key? key;

  final _i12.CustomerProfileScreenArguments customerProfileScreenArguments;

  @override
  String toString() {
    return 'FortunicaCustomerProfileArgs{key: $key, customerProfileScreenArguments: $customerProfileScreenArguments}';
  }
}

/// generated route for
/// [_i13.CustomerSessionsScreen]
class FortunicaCustomerSessions
    extends _i54.PageRouteInfo<FortunicaCustomerSessionsArgs> {
  FortunicaCustomerSessions({
    _i55.Key? key,
    required _i13.CustomerSessionsScreenArguments
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

  final _i55.Key? key;

  final _i13.CustomerSessionsScreenArguments customerSessionsScreenArguments;

  @override
  String toString() {
    return 'FortunicaCustomerSessionsArgs{key: $key, customerSessionsScreenArguments: $customerSessionsScreenArguments}';
  }
}

/// generated route for
/// [_i14.EditProfileScreen]
class FortunicaEditProfile
    extends _i54.PageRouteInfo<FortunicaEditProfileArgs> {
  FortunicaEditProfile({
    _i55.Key? key,
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

  final _i55.Key? key;

  final bool isAccountTimeout;

  @override
  String toString() {
    return 'FortunicaEditProfileArgs{key: $key, isAccountTimeout: $isAccountTimeout}';
  }
}

/// generated route for
/// [_i15.ForgotPasswordScreen]
class FortunicaForgotPassword
    extends _i54.PageRouteInfo<FortunicaForgotPasswordArgs> {
  FortunicaForgotPassword({
    _i55.Key? key,
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

  final _i55.Key? key;

  final String? resetToken;

  @override
  String toString() {
    return 'FortunicaForgotPasswordArgs{key: $key, resetToken: $resetToken}';
  }
}

/// generated route for
/// [_i16.GalleryPicturesScreen]
class FortunicaGalleryPictures
    extends _i54.PageRouteInfo<FortunicaGalleryPicturesArgs> {
  FortunicaGalleryPictures({
    _i55.Key? key,
    required _i16.GalleryPicturesScreenArguments galleryPicturesScreenArguments,
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

  final _i55.Key? key;

  final _i16.GalleryPicturesScreenArguments galleryPicturesScreenArguments;

  @override
  String toString() {
    return 'FortunicaGalleryPicturesArgs{key: $key, galleryPicturesScreenArguments: $galleryPicturesScreenArguments}';
  }
}

/// generated route for
/// [_i17.SupportScreen]
class FortunicaSupport extends _i54.PageRouteInfo<void> {
  const FortunicaSupport()
      : super(
          FortunicaSupport.name,
          path: 'fortunicaSupport',
        );

  static const String name = 'FortunicaSupport';
}

/// generated route for
/// [_i18.LoginScreen]
class FortunicaLogin extends _i54.PageRouteInfo<void> {
  const FortunicaLogin()
      : super(
          FortunicaLogin.name,
          path: 'fortunicaLogin',
        );

  static const String name = 'FortunicaLogin';
}

/// generated route for
/// [_i19.DashboardV1Screen]
class FortunicaDashboard extends _i54.PageRouteInfo<void> {
  const FortunicaDashboard()
      : super(
          FortunicaDashboard.name,
          path: 'fortunicaDashboard',
        );

  static const String name = 'FortunicaDashboard';
}

/// generated route for
/// [_i20.SessionsScreen]
class FortunicaChats extends _i54.PageRouteInfo<void> {
  const FortunicaChats()
      : super(
          FortunicaChats.name,
          path: 'fortunicaChats',
        );

  static const String name = 'FortunicaChats';
}

/// generated route for
/// [_i21.AccountScreen]
class FortunicaAccount extends _i54.PageRouteInfo<void> {
  const FortunicaAccount()
      : super(
          FortunicaAccount.name,
          path: 'fortunicaAccount',
        );

  static const String name = 'FortunicaAccount';
}

/// generated route for
/// [_i22.ZodiacAuthWrapper]
class ZodiacAuth extends _i54.PageRouteInfo<void> {
  const ZodiacAuth({List<_i54.PageRouteInfo>? children})
      : super(
          ZodiacAuth.name,
          path: 'zodiacAuth',
          initialChildren: children,
        );

  static const String name = 'ZodiacAuth';
}

/// generated route for
/// [_i23.HomeScreen]
class ZodiacHome extends _i54.PageRouteInfo<ZodiacHomeArgs> {
  ZodiacHome({
    _i55.Key? key,
    _i57.TabsTypes? initTab,
    List<_i54.PageRouteInfo>? children,
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

  final _i55.Key? key;

  final _i57.TabsTypes? initTab;

  @override
  String toString() {
    return 'ZodiacHomeArgs{key: $key, initTab: $initTab}';
  }
}

/// generated route for
/// [_i24.ArticleDetailsScreen]
class ZodiacArticleDetails
    extends _i54.PageRouteInfo<ZodiacArticleDetailsArgs> {
  ZodiacArticleDetails({
    _i55.Key? key,
    required int articleId,
  }) : super(
          ZodiacArticleDetails.name,
          path: 'zodiacArticleDetails',
          args: ZodiacArticleDetailsArgs(
            key: key,
            articleId: articleId,
          ),
        );

  static const String name = 'ZodiacArticleDetails';
}

class ZodiacArticleDetailsArgs {
  const ZodiacArticleDetailsArgs({
    this.key,
    required this.articleId,
  });

  final _i55.Key? key;

  final int articleId;

  @override
  String toString() {
    return 'ZodiacArticleDetailsArgs{key: $key, articleId: $articleId}';
  }
}

/// generated route for
/// [_i25.EditProfileScreen]
class ZodiacEditProfile extends _i54.PageRouteInfo<void> {
  const ZodiacEditProfile()
      : super(
          ZodiacEditProfile.name,
          path: 'zodiacEditProfile',
        );

  static const String name = 'ZodiacEditProfile';
}

/// generated route for
/// [_i26.GalleryPicturesScreen]
class ZodiacGalleryPictures
    extends _i54.PageRouteInfo<ZodiacGalleryPicturesArgs> {
  ZodiacGalleryPictures({
    _i55.Key? key,
    required _i26.GalleryPicturesScreenArguments galleryPicturesScreenArguments,
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

  final _i55.Key? key;

  final _i26.GalleryPicturesScreenArguments galleryPicturesScreenArguments;

  @override
  String toString() {
    return 'ZodiacGalleryPicturesArgs{key: $key, galleryPicturesScreenArguments: $galleryPicturesScreenArguments}';
  }
}

/// generated route for
/// [_i27.ForgotPasswordScreen]
class ZodiacForgotPassword extends _i54.PageRouteInfo<void> {
  const ZodiacForgotPassword()
      : super(
          ZodiacForgotPassword.name,
          path: 'zodiacForgotPassword',
        );

  static const String name = 'ZodiacForgotPassword';
}

/// generated route for
/// [_i28.NotificationsScreen]
class ZodiacNotifications extends _i54.PageRouteInfo<void> {
  const ZodiacNotifications()
      : super(
          ZodiacNotifications.name,
          path: 'zodiacNotifications',
        );

  static const String name = 'ZodiacNotifications';
}

/// generated route for
/// [_i29.ReviewsScreen]
class ZodiacReviews extends _i54.PageRouteInfo<void> {
  const ZodiacReviews()
      : super(
          ZodiacReviews.name,
          path: 'zodiacReviews',
        );

  static const String name = 'ZodiacReviews';
}

/// generated route for
/// [_i30.BalanceAndTransactionsScreen]
class ZodiacBalanceAndTransactions
    extends _i54.PageRouteInfo<ZodiacBalanceAndTransactionsArgs> {
  ZodiacBalanceAndTransactions({
    _i55.Key? key,
    required _i58.UserBalance userBalance,
  }) : super(
          ZodiacBalanceAndTransactions.name,
          path: 'zodiacBalanceAndTransactions',
          args: ZodiacBalanceAndTransactionsArgs(
            key: key,
            userBalance: userBalance,
          ),
        );

  static const String name = 'ZodiacBalanceAndTransactions';
}

class ZodiacBalanceAndTransactionsArgs {
  const ZodiacBalanceAndTransactionsArgs({
    this.key,
    required this.userBalance,
  });

  final _i55.Key? key;

  final _i58.UserBalance userBalance;

  @override
  String toString() {
    return 'ZodiacBalanceAndTransactionsArgs{key: $key, userBalance: $userBalance}';
  }
}

/// generated route for
/// [_i31.PhoneNumberScreen]
class ZodiacPhoneNumber extends _i54.PageRouteInfo<ZodiacPhoneNumberArgs> {
  ZodiacPhoneNumber({
    _i55.Key? key,
    required String? siteKey,
    required _i59.Phone phone,
  }) : super(
          ZodiacPhoneNumber.name,
          path: 'zodiacPhoneNumber',
          args: ZodiacPhoneNumberArgs(
            key: key,
            siteKey: siteKey,
            phone: phone,
          ),
        );

  static const String name = 'ZodiacPhoneNumber';
}

class ZodiacPhoneNumberArgs {
  const ZodiacPhoneNumberArgs({
    this.key,
    required this.siteKey,
    required this.phone,
  });

  final _i55.Key? key;

  final String? siteKey;

  final _i59.Phone phone;

  @override
  String toString() {
    return 'ZodiacPhoneNumberArgs{key: $key, siteKey: $siteKey, phone: $phone}';
  }
}

/// generated route for
/// [_i32.ServicesScreen]
class ZodiacServices extends _i54.PageRouteInfo<void> {
  const ZodiacServices()
      : super(
          ZodiacServices.name,
          path: 'zodiacServices',
        );

  static const String name = 'ZodiacServices';
}

/// generated route for
/// [_i33.CannedMessagesScreen]
class ZodiacCannedMessages extends _i54.PageRouteInfo<void> {
  const ZodiacCannedMessages()
      : super(
          ZodiacCannedMessages.name,
          path: 'zodiacCannedMessages',
        );

  static const String name = 'ZodiacCannedMessages';
}

/// generated route for
/// [_i34.SMSVerificationScreen]
class ZodiacSMSVerification
    extends _i54.PageRouteInfo<ZodiacSMSVerificationArgs> {
  ZodiacSMSVerification({
    _i55.Key? key,
    _i59.Phone? phoneNumber,
  }) : super(
          ZodiacSMSVerification.name,
          path: 'zodiacSMSVerification',
          args: ZodiacSMSVerificationArgs(
            key: key,
            phoneNumber: phoneNumber,
          ),
        );

  static const String name = 'ZodiacSMSVerification';
}

class ZodiacSMSVerificationArgs {
  const ZodiacSMSVerificationArgs({
    this.key,
    this.phoneNumber,
  });

  final _i55.Key? key;

  final _i59.Phone? phoneNumber;

  @override
  String toString() {
    return 'ZodiacSMSVerificationArgs{key: $key, phoneNumber: $phoneNumber}';
  }
}

/// generated route for
/// [_i35.PhoneNumberVerifiedScreen]
class ZodiacPhoneNumberVerified extends _i54.PageRouteInfo<void> {
  const ZodiacPhoneNumberVerified()
      : super(
          ZodiacPhoneNumberVerified.name,
          path: 'zodiacPhoneNumberVerified',
        );

  static const String name = 'ZodiacPhoneNumberVerified';
}

/// generated route for
/// [_i36.SupportScreen]
class ZodiacSupport extends _i54.PageRouteInfo<void> {
  const ZodiacSupport()
      : super(
          ZodiacSupport.name,
          path: 'zodiacSupport',
        );

  static const String name = 'ZodiacSupport';
}

/// generated route for
/// [_i37.LocalesListScreen]
class ZodiacLocalesList extends _i54.PageRouteInfo<ZodiacLocalesListArgs> {
  ZodiacLocalesList({
    _i55.Key? key,
    required void Function(String) returnCallback,
    required String title,
    String? oldSelectedLocaleCode,
    List<String>? unnecessaryLocalesCodes,
  }) : super(
          ZodiacLocalesList.name,
          path: 'zodiacLocalesList',
          args: ZodiacLocalesListArgs(
            key: key,
            returnCallback: returnCallback,
            title: title,
            oldSelectedLocaleCode: oldSelectedLocaleCode,
            unnecessaryLocalesCodes: unnecessaryLocalesCodes,
          ),
        );

  static const String name = 'ZodiacLocalesList';
}

class ZodiacLocalesListArgs {
  const ZodiacLocalesListArgs({
    this.key,
    required this.returnCallback,
    required this.title,
    this.oldSelectedLocaleCode,
    this.unnecessaryLocalesCodes,
  });

  final _i55.Key? key;

  final void Function(String) returnCallback;

  final String title;

  final String? oldSelectedLocaleCode;

  final List<String>? unnecessaryLocalesCodes;

  @override
  String toString() {
    return 'ZodiacLocalesListArgs{key: $key, returnCallback: $returnCallback, title: $title, oldSelectedLocaleCode: $oldSelectedLocaleCode, unnecessaryLocalesCodes: $unnecessaryLocalesCodes}';
  }
}

/// generated route for
/// [_i38.NotificationDetailsScreen]
class ZodiacNotificationDetails
    extends _i54.PageRouteInfo<ZodiacNotificationDetailsArgs> {
  ZodiacNotificationDetails({
    _i55.Key? key,
    required int pushId,
    required bool needRefreshList,
  }) : super(
          ZodiacNotificationDetails.name,
          path: 'zodiacNotificationDetails',
          args: ZodiacNotificationDetailsArgs(
            key: key,
            pushId: pushId,
            needRefreshList: needRefreshList,
          ),
        );

  static const String name = 'ZodiacNotificationDetails';
}

class ZodiacNotificationDetailsArgs {
  const ZodiacNotificationDetailsArgs({
    this.key,
    required this.pushId,
    required this.needRefreshList,
  });

  final _i55.Key? key;

  final int pushId;

  final bool needRefreshList;

  @override
  String toString() {
    return 'ZodiacNotificationDetailsArgs{key: $key, pushId: $pushId, needRefreshList: $needRefreshList}';
  }
}

/// generated route for
/// [_i39.ChatScreen]
class ZodiacChat extends _i54.PageRouteInfo<ZodiacChatArgs> {
  ZodiacChat({
    _i55.Key? key,
    required _i60.UserData userData,
    bool fromStartingChat = false,
  }) : super(
          ZodiacChat.name,
          path: 'zodiacChat',
          args: ZodiacChatArgs(
            key: key,
            userData: userData,
            fromStartingChat: fromStartingChat,
          ),
        );

  static const String name = 'ZodiacChat';
}

class ZodiacChatArgs {
  const ZodiacChatArgs({
    this.key,
    required this.userData,
    this.fromStartingChat = false,
  });

  final _i55.Key? key;

  final _i60.UserData userData;

  final bool fromStartingChat;

  @override
  String toString() {
    return 'ZodiacChatArgs{key: $key, userData: $userData, fromStartingChat: $fromStartingChat}';
  }
}

/// generated route for
/// [_i40.SendImageScreen]
class ZodiacSendImage extends _i54.PageRouteInfo<ZodiacSendImageArgs> {
  ZodiacSendImage({
    _i55.Key? key,
    required _i61.File image,
  }) : super(
          ZodiacSendImage.name,
          path: 'zodiacSendImage',
          args: ZodiacSendImageArgs(
            key: key,
            image: image,
          ),
        );

  static const String name = 'ZodiacSendImage';
}

class ZodiacSendImageArgs {
  const ZodiacSendImageArgs({
    this.key,
    required this.image,
  });

  final _i55.Key? key;

  final _i61.File image;

  @override
  String toString() {
    return 'ZodiacSendImageArgs{key: $key, image: $image}';
  }
}

/// generated route for
/// [_i41.AddServiceScreen]
class ZodiacAddService extends _i54.PageRouteInfo<void> {
  const ZodiacAddService()
      : super(
          ZodiacAddService.name,
          path: 'zodiacAddService',
        );

  static const String name = 'ZodiacAddService';
}

/// generated route for
/// [_i42.DuplicateServiceScreen]
class ZodiacDuplicateService
    extends _i54.PageRouteInfo<ZodiacDuplicateServiceArgs> {
  ZodiacDuplicateService({
    _i55.Key? key,
    required void Function(Map<String, dynamic>) returnCallback,
    required List<_i62.ServiceItem> approvedServices,
    int? oldDuplicatedServiceId,
  }) : super(
          ZodiacDuplicateService.name,
          path: 'zodiacDuplicateService',
          args: ZodiacDuplicateServiceArgs(
            key: key,
            returnCallback: returnCallback,
            approvedServices: approvedServices,
            oldDuplicatedServiceId: oldDuplicatedServiceId,
          ),
        );

  static const String name = 'ZodiacDuplicateService';
}

class ZodiacDuplicateServiceArgs {
  const ZodiacDuplicateServiceArgs({
    this.key,
    required this.returnCallback,
    required this.approvedServices,
    this.oldDuplicatedServiceId,
  });

  final _i55.Key? key;

  final void Function(Map<String, dynamic>) returnCallback;

  final List<_i62.ServiceItem> approvedServices;

  final int? oldDuplicatedServiceId;

  @override
  String toString() {
    return 'ZodiacDuplicateServiceArgs{key: $key, returnCallback: $returnCallback, approvedServices: $approvedServices, oldDuplicatedServiceId: $oldDuplicatedServiceId}';
  }
}

/// generated route for
/// [_i43.EditServiceScreen]
class ZodiacEditService extends _i54.PageRouteInfo<ZodiacEditServiceArgs> {
  ZodiacEditService({
    _i55.Key? key,
    required int serviceId,
  }) : super(
          ZodiacEditService.name,
          path: 'zodiacEditService',
          args: ZodiacEditServiceArgs(
            key: key,
            serviceId: serviceId,
          ),
        );

  static const String name = 'ZodiacEditService';
}

class ZodiacEditServiceArgs {
  const ZodiacEditServiceArgs({
    this.key,
    required this.serviceId,
  });

  final _i55.Key? key;

  final int serviceId;

  @override
  String toString() {
    return 'ZodiacEditServiceArgs{key: $key, serviceId: $serviceId}';
  }
}

/// generated route for
/// [_i44.CompleteServiceScreen]
class ZodiacCompleteService extends _i54.PageRouteInfo<void> {
  const ZodiacCompleteService()
      : super(
          ZodiacCompleteService.name,
          path: 'zodiacCompleteService',
        );

  static const String name = 'ZodiacCompleteService';
}

/// generated route for
/// [_i45.SelectCategoriesScreen]
class ZodiacSelectCategories
    extends _i54.PageRouteInfo<ZodiacSelectCategoriesArgs> {
  ZodiacSelectCategories({
    _i55.Key? key,
    required List<int> selectedCategoryIds,
    required dynamic Function(
      List<_i63.CategoryInfo>,
      int,
    ) returnCallback,
    int? mainCategoryId,
  }) : super(
          ZodiacSelectCategories.name,
          path: 'zodiacSelectCategories',
          args: ZodiacSelectCategoriesArgs(
            key: key,
            selectedCategoryIds: selectedCategoryIds,
            returnCallback: returnCallback,
            mainCategoryId: mainCategoryId,
          ),
        );

  static const String name = 'ZodiacSelectCategories';
}

class ZodiacSelectCategoriesArgs {
  const ZodiacSelectCategoriesArgs({
    this.key,
    required this.selectedCategoryIds,
    required this.returnCallback,
    this.mainCategoryId,
  });

  final _i55.Key? key;

  final List<int> selectedCategoryIds;

  final dynamic Function(
    List<_i63.CategoryInfo>,
    int,
  ) returnCallback;

  final int? mainCategoryId;

  @override
  String toString() {
    return 'ZodiacSelectCategoriesArgs{key: $key, selectedCategoryIds: $selectedCategoryIds, returnCallback: $returnCallback, mainCategoryId: $mainCategoryId}';
  }
}

/// generated route for
/// [_i46.CategoriesMethodsListScreen]
class ZodiacCategoriesMethodsList
    extends _i54.PageRouteInfo<ZodiacCategoriesMethodsListArgs> {
  ZodiacCategoriesMethodsList({
    _i55.Key? key,
    required String title,
    required List<_i46.CategoriesMethodsListItem> items,
    required void Function(int) returnCallback,
    int? initialSelectedId,
  }) : super(
          ZodiacCategoriesMethodsList.name,
          path: 'zodiacCategoriesMethodsList',
          args: ZodiacCategoriesMethodsListArgs(
            key: key,
            title: title,
            items: items,
            returnCallback: returnCallback,
            initialSelectedId: initialSelectedId,
          ),
        );

  static const String name = 'ZodiacCategoriesMethodsList';
}

class ZodiacCategoriesMethodsListArgs {
  const ZodiacCategoriesMethodsListArgs({
    this.key,
    required this.title,
    required this.items,
    required this.returnCallback,
    this.initialSelectedId,
  });

  final _i55.Key? key;

  final String title;

  final List<_i46.CategoriesMethodsListItem> items;

  final void Function(int) returnCallback;

  final int? initialSelectedId;

  @override
  String toString() {
    return 'ZodiacCategoriesMethodsListArgs{key: $key, title: $title, items: $items, returnCallback: $returnCallback, initialSelectedId: $initialSelectedId}';
  }
}

/// generated route for
/// [_i47.SelectMethodsScreen]
class ZodiacSelectMethods extends _i54.PageRouteInfo<ZodiacSelectMethodsArgs> {
  ZodiacSelectMethods({
    _i55.Key? key,
    required List<int> selectedMethodIds,
    required dynamic Function(
      List<_i63.CategoryInfo>,
      int,
    ) returnCallback,
    int? mainMethodId,
  }) : super(
          ZodiacSelectMethods.name,
          path: 'zodiacSelectMethods',
          args: ZodiacSelectMethodsArgs(
            key: key,
            selectedMethodIds: selectedMethodIds,
            returnCallback: returnCallback,
            mainMethodId: mainMethodId,
          ),
        );

  static const String name = 'ZodiacSelectMethods';
}

class ZodiacSelectMethodsArgs {
  const ZodiacSelectMethodsArgs({
    this.key,
    required this.selectedMethodIds,
    required this.returnCallback,
    this.mainMethodId,
  });

  final _i55.Key? key;

  final List<int> selectedMethodIds;

  final dynamic Function(
    List<_i63.CategoryInfo>,
    int,
  ) returnCallback;

  final int? mainMethodId;

  @override
  String toString() {
    return 'ZodiacSelectMethodsArgs{key: $key, selectedMethodIds: $selectedMethodIds, returnCallback: $returnCallback, mainMethodId: $mainMethodId}';
  }
}

/// generated route for
/// [_i48.AutoReplyScreen]
class ZodiacAutoReply extends _i54.PageRouteInfo<void> {
  const ZodiacAutoReply()
      : super(
          ZodiacAutoReply.name,
          path: 'zodiacAutoReply',
        );

  static const String name = 'ZodiacAutoReply';
}

/// generated route for
/// [_i49.LoginScreen]
class ZodiacLogin extends _i54.PageRouteInfo<void> {
  const ZodiacLogin()
      : super(
          ZodiacLogin.name,
          path: 'zodiacLogin',
        );

  static const String name = 'ZodiacLogin';
}

/// generated route for
/// [_i50.DashboardScreen]
class ZodiacDashboard extends _i54.PageRouteInfo<void> {
  const ZodiacDashboard()
      : super(
          ZodiacDashboard.name,
          path: 'zodiacDashboard',
        );

  static const String name = 'ZodiacDashboard';
}

/// generated route for
/// [_i51.SessionsScreen]
class ZodiacChats extends _i54.PageRouteInfo<void> {
  const ZodiacChats()
      : super(
          ZodiacChats.name,
          path: 'zodiacChats',
        );

  static const String name = 'ZodiacChats';
}

/// generated route for
/// [_i52.AccountScreen]
class ZodiacAccount extends _i54.PageRouteInfo<void> {
  const ZodiacAccount()
      : super(
          ZodiacAccount.name,
          path: 'zodiacAccount',
        );

  static const String name = 'ZodiacAccount';
}

/// generated route for
/// [_i53.ArticlesScreen]
class ZodiacArticles extends _i54.PageRouteInfo<void> {
  const ZodiacArticles()
      : super(
          ZodiacArticles.name,
          path: 'zodiacArticles',
        );

  static const String name = 'ZodiacArticles';
}
