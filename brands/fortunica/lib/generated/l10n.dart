// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class SFortunica {
  SFortunica();

  static SFortunica? _current;

  static SFortunica get current {
    assert(_current != null,
        'No instance of SFortunica was loaded. Try to initialize the SFortunica delegate before accessing SFortunica.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<SFortunica> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = SFortunica();
      SFortunica._current = instance;

      return instance;
    });
  }

  static SFortunica of(BuildContext context) {
    final instance = SFortunica.maybeOf(context);
    assert(instance != null,
        'No instance of SFortunica present in the widget tree. Did you add SFortunica.delegate in localizationsDelegates?');
    return instance!;
  }

  static SFortunica? maybeOf(BuildContext context) {
    return Localizations.of<SFortunica>(context, SFortunica);
  }

  /// `Back`
  String get backFortunica {
    return Intl.message(
      'Back',
      name: 'backFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginFortunica {
    return Intl.message(
      'Login',
      name: 'loginFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgotPasswordFortunica {
    return Intl.message(
      'Forgot password',
      name: 'forgotPasswordFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailFortunica {
    return Intl.message(
      'Email',
      name: 'emailFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordFortunica {
    return Intl.message(
      'Password',
      name: 'passwordFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new password`
  String get confirmNewPasswordFortunica {
    return Intl.message(
      'Confirm new password',
      name: 'confirmNewPasswordFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePasswordFortunica {
    return Intl.message(
      'Change password',
      name: 'changePasswordFortunica',
      desc: '',
      args: [],
    );
  }

  /// `The passwords must match`
  String get thePasswordsMustMatchFortunica {
    return Intl.message(
      'The passwords must match',
      name: 'thePasswordsMustMatchFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Please enter at least 6 characters`
  String get pleaseEnterAtLeast6CharactersFortunica {
    return Intl.message(
      'Please enter at least 6 characters',
      name: 'pleaseEnterAtLeast6CharactersFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Please, insert correct email`
  String get pleaseInsertCorrectEmailFortunica {
    return Intl.message(
      'Please, insert correct email',
      name: 'pleaseInsertCorrectEmailFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Select brand`
  String get chooseBrandFortunica {
    return Intl.message(
      'Select brand',
      name: 'chooseBrandFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Coming soon!`
  String get comingSoonFortunica {
    return Intl.message(
      'Coming soon!',
      name: 'comingSoonFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signInFortunica {
    return Intl.message(
      'Sign in',
      name: 'signInFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get saveFortunica {
    return Intl.message(
      'Save',
      name: 'saveFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password`
  String get forgotYourPasswordFortunica {
    return Intl.message(
      'Forgot your password',
      name: 'forgotYourPasswordFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Request new password`
  String get requestNewPasswordFortunica {
    return Intl.message(
      'Request new password',
      name: 'requestNewPasswordFortunica',
      desc: '',
      args: [],
    );
  }

  /// `The user was not found`
  String get theUserWasNotFoundFortunica {
    return Intl.message(
      'The user was not found',
      name: 'theUserWasNotFoundFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get editProfileFortunica {
    return Intl.message(
      'Edit profile',
      name: 'editProfileFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Add cover picture`
  String get addCoverPictureFortunica {
    return Intl.message(
      'Add cover picture',
      name: 'addCoverPictureFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Change photo`
  String get changePhotoFortunica {
    return Intl.message(
      'Change photo',
      name: 'changePhotoFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Pseudonym/Profile Name`
  String get nicknameFortunica {
    return Intl.message(
      'Pseudonym/Profile Name',
      name: 'nicknameFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Name can be changed only on Advisor Tool`
  String get nameCanBeChangedOnlyOnAdvisorToolFortunica {
    return Intl.message(
      'Name can be changed only on Advisor Tool',
      name: 'nameCanBeChangedOnlyOnAdvisorToolFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Status Text`
  String get statusTextFortunica {
    return Intl.message(
      'Status Text',
      name: 'statusTextFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Profile Text`
  String get profileTextFortunica {
    return Intl.message(
      'Profile Text',
      name: 'profileTextFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Add photos`
  String get addGalleryPicturesFortunica {
    return Intl.message(
      'Add photos',
      name: 'addGalleryPicturesFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Add more`
  String get addMoreFortunica {
    return Intl.message(
      'Add more',
      name: 'addMoreFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Brands`
  String get workspacesFortunica {
    return Intl.message(
      'Brands',
      name: 'workspacesFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Customer Support`
  String get customerSupportFortunica {
    return Intl.message(
      'Customer Support',
      name: 'customerSupportFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelFortunica {
    return Intl.message(
      'Cancel',
      name: 'cancelFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Cancel sending`
  String get cancelSendingFortunica {
    return Intl.message(
      'Cancel sending',
      name: 'cancelSendingFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Choose email app`
  String get chooseEmailAppFortunica {
    return Intl.message(
      'Choose email app',
      name: 'chooseEmailAppFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Open email`
  String get openEmailFortunica {
    return Intl.message(
      'Open email',
      name: 'openEmailFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Quick Question`
  String get publicFortunica {
    return Intl.message(
      'Quick Question',
      name: 'publicFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get searchFortunica {
    return Intl.message(
      'Search',
      name: 'searchFortunica',
      desc: '',
      args: [],
    );
  }

  /// `I'm available now`
  String get imAvailableNowFortunica {
    return Intl.message(
      'I\'m available now',
      name: 'imAvailableNowFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notificationsFortunica {
    return Intl.message(
      'Notifications',
      name: 'notificationsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Profile Preview`
  String get previewAccountFortunica {
    return Intl.message(
      'Profile Preview',
      name: 'previewAccountFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviewsFortunica {
    return Intl.message(
      'Reviews',
      name: 'reviewsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balanceTransactionsFortunica {
    return Intl.message(
      'Balance',
      name: 'balanceTransactionsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsFortunica {
    return Intl.message(
      'Settings',
      name: 'settingsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Not enough conversations? Check our Profile Guide.`
  String get notEnoughConversationsCheckOurProfileGuideFortunica {
    return Intl.message(
      'Not enough conversations? Check our Profile Guide.',
      name: 'notEnoughConversationsCheckOurProfileGuideFortunica',
      desc: '',
      args: [],
    );
  }

  /// `See more`
  String get seeMoreFortunica {
    return Intl.message(
      'See more',
      name: 'seeMoreFortunica',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get newFortunica {
    return Intl.message(
      'New',
      name: 'newFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Mandatory`
  String get mandatoryFortunica {
    return Intl.message(
      'Mandatory',
      name: 'mandatoryFortunica',
      desc: '',
      args: [],
    );
  }

  /// `New article is available!`
  String get newMandatoryArticleIsAvailableFortunica {
    return Intl.message(
      'New article is available!',
      name: 'newMandatoryArticleIsAvailableFortunica',
      desc: '',
      args: [],
    );
  }

  /// `You have {count} days to read it before your account will get blocked!`
  String youHaveXdaystoReadItBeforeYourAccountWillGetBlockedFortunica(
      Object count) {
    return Intl.message(
      'You have $count days to read it before your account will get blocked!',
      name: 'youHaveXdaystoReadItBeforeYourAccountWillGetBlockedFortunica',
      desc: '',
      args: [count],
    );
  }

  /// `Take me there`
  String get takeMeThereFortunica {
    return Intl.message(
      'Take me there',
      name: 'takeMeThereFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Change cover picture`
  String get changeCoverPictureFortunica {
    return Intl.message(
      'Change cover picture',
      name: 'changeCoverPictureFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Please enter at least 3 characters`
  String get pleaseEnterAtLeast3CharactersFortunica {
    return Intl.message(
      'Please enter at least 3 characters',
      name: 'pleaseEnterAtLeast3CharactersFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Resources`
  String get resourcesFortunica {
    return Intl.message(
      'Resources',
      name: 'resourcesFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Stats`
  String get statsFortunica {
    return Intl.message(
      'Stats',
      name: 'statsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Courses`
  String get coursesFortunica {
    return Intl.message(
      'Courses',
      name: 'coursesFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get todayFortunica {
    return Intl.message(
      'Today',
      name: 'todayFortunica',
      desc: '',
      args: [],
    );
  }

  /// `This Month`
  String get thisMonthFortunica {
    return Intl.message(
      'This Month',
      name: 'thisMonthFortunica',
      desc: '',
      args: [],
    );
  }

  /// `This Week`
  String get thisWeekFortunica {
    return Intl.message(
      'This Week',
      name: 'thisWeekFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Customers`
  String get customersFortunica {
    return Intl.message(
      'Customers',
      name: 'customersFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Customers who come back to you after buying the first session on any platform`
  String get customersComeBackToYouAfterBuyingFirstSessionPlatformFortunica {
    return Intl.message(
      'Customers who come back to you after buying the first session on any platform',
      name: 'customersComeBackToYouAfterBuyingFirstSessionPlatformFortunica',
      desc: '',
      args: [],
    );
  }

  /// `New Customers`
  String get newUsersFortunica {
    return Intl.message(
      'New Customers',
      name: 'newUsersFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Loyal Customers`
  String get loyalUsersFortunica {
    return Intl.message(
      'Loyal Customers',
      name: 'loyalUsersFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Similar articles`
  String get similarArticlesFortunica {
    return Intl.message(
      'Similar articles',
      name: 'similarArticlesFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Will be available in`
  String get willBeAvailableInFortunica {
    return Intl.message(
      'Will be available in',
      name: 'willBeAvailableInFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure that you want to change your status to Offline?`
  String get areYouSureThatYouWantToChangeYourStatusFortunica {
    return Intl.message(
      'Are you sure that you want to change your status to Offline?',
      name: 'areYouSureThatYouWantToChangeYourStatusFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Yes, I’m sure`
  String get yesImSureFortunica {
    return Intl.message(
      'Yes, I’m sure',
      name: 'yesImSureFortunica',
      desc: '',
      args: [],
    );
  }

  /// `No, I changed my mind`
  String get noIChangedMyMindFortunica {
    return Intl.message(
      'No, I changed my mind',
      name: 'noIChangedMyMindFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get doneFortunica {
    return Intl.message(
      'Done',
      name: 'doneFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Earned`
  String get earnedFortunica {
    return Intl.message(
      'Earned',
      name: 'earnedFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get totalFortunica {
    return Intl.message(
      'Total',
      name: 'totalFortunica',
      desc: '',
      args: [],
    );
  }

  /// `All Markets`
  String get totalMarketsFortunica {
    return Intl.message(
      'All Markets',
      name: 'totalMarketsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboardFortunica {
    return Intl.message(
      'Dashboard',
      name: 'dashboardFortunica',
      desc: '',
      args: [],
    );
  }

  /// `About Me`
  String get aboutMeFortunica {
    return Intl.message(
      'About Me',
      name: 'aboutMeFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Quick Questions`
  String get quickAnswersFortunica {
    return Intl.message(
      'Quick Questions',
      name: 'quickAnswersFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Born`
  String get bornFortunica {
    return Intl.message(
      'Born',
      name: 'bornFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chatsFortunica {
    return Intl.message(
      'Chats',
      name: 'chatsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Calls`
  String get callsFortunica {
    return Intl.message(
      'Calls',
      name: 'callsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get servicesFortunica {
    return Intl.message(
      'Balance',
      name: 'servicesFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Add new`
  String get addNewFortunica {
    return Intl.message(
      'Add new',
      name: 'addNewFortunica',
      desc: '',
      args: [],
    );
  }

  /// `You don’t have any notes yet`
  String get youDoNotHaveAnyNotesYetFortunica {
    return Intl.message(
      'You don’t have any notes yet',
      name: 'youDoNotHaveAnyNotesYetFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Add Note`
  String get addNoteFortunica {
    return Intl.message(
      'Add Note',
      name: 'addNoteFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get titleFortunica {
    return Intl.message(
      'Title',
      name: 'titleFortunica',
      desc: '',
      args: [],
    );
  }

  /// `You have not completed any sessions yet`
  String get youHaveNotCompletedAnySessionsYetFortunica {
    return Intl.message(
      'You have not completed any sessions yet',
      name: 'youHaveNotCompletedAnySessionsYetFortunica',
      desc: '',
      args: [],
    );
  }

  /// `No sessions were completed this month`
  String get youHaveNotYetCompletedThisMonthsSessionsFortunica {
    return Intl.message(
      'No sessions were completed this month',
      name: 'youHaveNotYetCompletedThisMonthsSessionsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Avg Daily Earnings`
  String get avgDailyEarningsFortunica {
    return Intl.message(
      'Avg Daily Earnings',
      name: 'avgDailyEarningsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Performance Overview Analytics`
  String get performanceOverviewAnalyticsFortunica {
    return Intl.message(
      'Performance Overview Analytics',
      name: 'performanceOverviewAnalyticsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Edit Note`
  String get editNoteFortunica {
    return Intl.message(
      'Edit Note',
      name: 'editNoteFortunica',
      desc: '',
      args: [],
    );
  }

  /// `All Markets`
  String get allMarketsFortunica {
    return Intl.message(
      'All Markets',
      name: 'allMarketsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Market:`
  String get marketFortunica {
    return Intl.message(
      'Market:',
      name: 'marketFortunica',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get allFortunica {
    return Intl.message(
      'All',
      name: 'allFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Private Questions`
  String get privateQuestionsFortunica {
    return Intl.message(
      'Private Questions',
      name: 'privateQuestionsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Only Premium Sessions`
  String get onlyPremiumProductsFortunica {
    return Intl.message(
      'Only Premium Sessions',
      name: 'onlyPremiumProductsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `No questions, yet.`
  String get noQuestionsYetFortunica {
    return Intl.message(
      'No questions, yet.',
      name: 'noQuestionsYetFortunica',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection.`
  String get noInternetConnectionFortunica {
    return Intl.message(
      'No internet connection.',
      name: 'noInternetConnectionFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Uh-oh. It looks like you've lost your connection. Please try again.`
  String get uhOhItLooksLikeYouVeLostYourConnectionPleaseTryAgainFortunica {
    return Intl.message(
      'Uh-oh. It looks like you\'ve lost your connection. Please try again.',
      name: 'uhOhItLooksLikeYouVeLostYourConnectionPleaseTryAgainFortunica',
      desc: '',
      args: [],
    );
  }

  /// `You can change the status again in 1 hour.`
  String get youWillBeAbleToChangeYourStatusBackInFortunica {
    return Intl.message(
      'You can change the status again in 1 hour.',
      name: 'youWillBeAbleToChangeYourStatusBackInFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetPasswordFortunica {
    return Intl.message(
      'Reset password',
      name: 'resetPasswordFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been banned. Please contact Advisor Management.`
  String get yourAccountHasBeenBlockedPleaseContactYourAdvisorManagerFortunica {
    return Intl.message(
      'Your account has been banned. Please contact Advisor Management.',
      name: 'yourAccountHasBeenBlockedPleaseContactYourAdvisorManagerFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get accountFortunica {
    return Intl.message(
      'Account',
      name: 'accountFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Articles`
  String get articlesFortunica {
    return Intl.message(
      'Articles',
      name: 'articlesFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Sessions`
  String get sessionsFortunica {
    return Intl.message(
      'Sessions',
      name: 'sessionsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `from {minRecordDurationInSec} sec to {maxRecordDurationInMinutes} min`
  String fromXsecToYminFortunica(
      Object minRecordDurationInSec, Object maxRecordDurationInMinutes) {
    return Intl.message(
      'from $minRecordDurationInSec sec to $maxRecordDurationInMinutes min',
      name: 'fromXsecToYminFortunica',
      desc: '',
      args: [minRecordDurationInSec, maxRecordDurationInMinutes],
    );
  }

  /// `Do you want to delete image?`
  String get doYouWantToDeleteImageFortunica {
    return Intl.message(
      'Do you want to delete image?',
      name: 'doYouWantToDeleteImageFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get tryAgainFortunica {
    return Intl.message(
      'Try again',
      name: 'tryAgainFortunica',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get okFortunica {
    return Intl.message(
      'OK',
      name: 'okFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirmFortunica {
    return Intl.message(
      'Confirm',
      name: 'confirmFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Return`
  String get returnFortunica {
    return Intl.message(
      'Return',
      name: 'returnFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get noteFortunica {
    return Intl.message(
      'Note',
      name: 'noteFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Live`
  String get liveFortunica {
    return Intl.message(
      'Live',
      name: 'liveFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Incomplete`
  String get incompleteFortunica {
    return Intl.message(
      'Incomplete',
      name: 'incompleteFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Blocked`
  String get blockedFortunica {
    return Intl.message(
      'Blocked',
      name: 'blockedFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Legal block`
  String get legalBlockFortunica {
    return Intl.message(
      'Legal block',
      name: 'legalBlockFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Offline`
  String get offlineFortunica {
    return Intl.message(
      'Offline',
      name: 'offlineFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Go to Account`
  String get goToAccountFortunica {
    return Intl.message(
      'Go to Account',
      name: 'goToAccountFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Active chat`
  String get activeChatFortunica {
    return Intl.message(
      'Active chat',
      name: 'activeChatFortunica',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get historyFortunica {
    return Intl.message(
      'History',
      name: 'historyFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileFortunica {
    return Intl.message(
      'Profile',
      name: 'profileFortunica',
      desc: '',
      args: [],
    );
  }

  /// `PERSONAL DETAILS`
  String get personalDetailsFortunica {
    return Intl.message(
      'PERSONAL DETAILS',
      name: 'personalDetailsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Take question`
  String get takeQuestionFortunica {
    return Intl.message(
      'Take question',
      name: 'takeQuestionFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Photo is required`
  String get photoIsRequiredFortunica {
    return Intl.message(
      'Photo is required',
      name: 'photoIsRequiredFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Your Username`
  String get yourUsernameFortunica {
    return Intl.message(
      'Your Username',
      name: 'yourUsernameFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get maleFortunica {
    return Intl.message(
      'Male',
      name: 'maleFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get femaleFortunica {
    return Intl.message(
      'Female',
      name: 'femaleFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Non-binary`
  String get nonBinaryFortunica {
    return Intl.message(
      'Non-binary',
      name: 'nonBinaryFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Prefer not to answer`
  String get preferNotToAnswerFortunica {
    return Intl.message(
      'Prefer not to answer',
      name: 'preferNotToAnswerFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Audio message`
  String get audioMessageFortunica {
    return Intl.message(
      'Audio message',
      name: 'audioMessageFortunica',
      desc: '',
      args: [],
    );
  }

  /// `We didn’t find anything`
  String get weDidntFindAnythingFortunica {
    return Intl.message(
      'We didn’t find anything',
      name: 'weDidntFindAnythingFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get otherFortunica {
    return Intl.message(
      'Other',
      name: 'otherFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Private`
  String get privateFortunica {
    return Intl.message(
      'Private',
      name: 'privateFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Card Reading`
  String get tarotFortunica {
    return Intl.message(
      'Card Reading',
      name: 'tarotFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Palm Reading`
  String get palmReadingFortunica {
    return Intl.message(
      'Palm Reading',
      name: 'palmReadingFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Astral Chart`
  String get astrologyFortunica {
    return Intl.message(
      'Astral Chart',
      name: 'astrologyFortunica',
      desc: '',
      args: [],
    );
  }

  /// `360° Reading`
  String get reading360Fortunica {
    return Intl.message(
      '360° Reading',
      name: 'reading360Fortunica',
      desc: '',
      args: [],
    );
  }

  /// `Soulmate Reading`
  String get soulmateReadingFortunica {
    return Intl.message(
      'Soulmate Reading',
      name: 'soulmateReadingFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Love Crush Reading`
  String get loveCrushReadingFortunica {
    return Intl.message(
      'Love Crush Reading',
      name: 'loveCrushReadingFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Ritual Session`
  String get ritualFortunica {
    return Intl.message(
      'Ritual Session',
      name: 'ritualFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Tips`
  String get tipsFortunica {
    return Intl.message(
      'Tips',
      name: 'tipsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Questions`
  String get questionsFortunica {
    return Intl.message(
      'Questions',
      name: 'questionsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get questionFortunica {
    return Intl.message(
      'Question',
      name: 'questionFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Session`
  String get sessionFortunica {
    return Intl.message(
      'Session',
      name: 'sessionFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Check your internet connection`
  String get checkYourInternetConnectionFortunica {
    return Intl.message(
      'Check your internet connection',
      name: 'checkYourInternetConnectionFortunica',
      desc: '',
      args: [],
    );
  }

  /// `You can’t send this message because it’s less than {minRecordDurationInSec} seconds`
  String youCantSendThisMessageBecauseItsLessThanXSecondsFortunica(
      Object minRecordDurationInSec) {
    return Intl.message(
      'You can’t send this message because it’s less than $minRecordDurationInSec seconds',
      name: 'youCantSendThisMessageBecauseItsLessThanXSecondsFortunica',
      desc: '',
      args: [minRecordDurationInSec],
    );
  }

  /// `The maximum size of the attachments is {maxAttachmentSizeInMb}Mb`
  String theMaximumSizeOfTheAttachmentsIsXMbFortunica(
      Object maxAttachmentSizeInMb) {
    return Intl.message(
      'The maximum size of the attachments is ${maxAttachmentSizeInMb}Mb',
      name: 'theMaximumSizeOfTheAttachmentsIsXMbFortunica',
      desc: '',
      args: [maxAttachmentSizeInMb],
    );
  }

  /// `This question will be returned to the queue after {counter}`
  String thisQuestionWillBeReturnedToTheGeneralListAfterCounterFortunica(
      Object counter) {
    return Intl.message(
      'This question will be returned to the queue after $counter',
      name: 'thisQuestionWillBeReturnedToTheGeneralListAfterCounterFortunica',
      desc: '',
      args: [counter],
    );
  }

  /// `The answer is not possible, this question will be returned to the queue in ~ 1 min`
  String
      get theAnswerIsNotPossibleThisQuestionWillBeReturnedToTheGeneralListIn1mFortunica {
    return Intl.message(
      'The answer is not possible, this question will be returned to the queue in ~ 1 min',
      name:
          'theAnswerIsNotPossibleThisQuestionWillBeReturnedToTheGeneralListIn1mFortunica',
      desc: '',
      args: [],
    );
  }

  /// `You have an active session`
  String get youHaveAnActiveSessionFortunica {
    return Intl.message(
      'You have an active session',
      name: 'youHaveAnActiveSessionFortunica',
      desc: '',
      args: [],
    );
  }

  /// `You have a private message`
  String get youHaveAPrivateMessageFortunica {
    return Intl.message(
      'You have a private message',
      name: 'youHaveAPrivateMessageFortunica',
      desc: '',
      args: [],
    );
  }

  /// `You have a few active sessions`
  String get youHaveAFewActiveSessionsFortunica {
    return Intl.message(
      'You have a few active sessions',
      name: 'youHaveAFewActiveSessionsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get unknownErrorFortunica {
    return Intl.message(
      'Unknown error',
      name: 'unknownErrorFortunica',
      desc: '',
      args: [],
    );
  }

  /// `When you help your first client, you will see your session history here.`
  String
      get whenYouHelpYourFirstClientYouWillSeeYourSessionHistoryHereFortunica {
    return Intl.message(
      'When you help your first client, you will see your session history here.',
      name:
          'whenYouHelpYourFirstClientYouWillSeeYourSessionHistoryHereFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Your client session history will appear here`
  String get yourClientSessionHistoryWillAppearHereFortunica {
    return Intl.message(
      'Your client session history will appear here',
      name: 'yourClientSessionHistoryWillAppearHereFortunica',
      desc: '',
      args: [],
    );
  }

  /// `No sessions, yet.`
  String get noSessionsYetFortunica {
    return Intl.message(
      'No sessions, yet.',
      name: 'noSessionsYetFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Status Text may not exceed 300 characters`
  String get statusTextMayNotExceed300CharactersFortunica {
    return Intl.message(
      'Status Text may not exceed 300 characters',
      name: 'statusTextMayNotExceed300CharactersFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Required field`
  String get requiredFieldFortunica {
    return Intl.message(
      'Required field',
      name: 'requiredFieldFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Customers want to know you're a real person. The more photos you add, the more trust you can build.`
  String
      get customersWantToKnowYouReARealPersonTheMorePhotosYouAddTheMoreTrustYouCanBuildFortunica {
    return Intl.message(
      'Customers want to know you\'re a real person. The more photos you add, the more trust you can build.',
      name:
          'customersWantToKnowYouReARealPersonTheMorePhotosYouAddTheMoreTrustYouCanBuildFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Complete your profile to start work`
  String get completeYourProfileToStartWorkFortunica {
    return Intl.message(
      'Complete your profile to start work',
      name: 'completeYourProfileToStartWorkFortunica',
      desc: '',
      args: [],
    );
  }

  /// `You're not live on the platform`
  String get youReNotLiveOnThePlatformFortunica {
    return Intl.message(
      'You\'re not live on the platform',
      name: 'youReNotLiveOnThePlatformFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Please ensure your profile is completed for all languages. Need help? Contact your manager.`
  String
      get pleaseEnsureYourProfileIsCompletedForAllLanguagesNeedHelpContactYourManagerFortunica {
    return Intl.message(
      'Please ensure your profile is completed for all languages. Need help? Contact your manager.',
      name:
          'pleaseEnsureYourProfileIsCompletedForAllLanguagesNeedHelpContactYourManagerFortunica',
      desc: '',
      args: [],
    );
  }

  /// `You need to accept the advisor contract`
  String get youNeedToAcceptTheAdvisorContractFortunica {
    return Intl.message(
      'You need to accept the advisor contract',
      name: 'youNeedToAcceptTheAdvisorContractFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Please login to the web version of your account.`
  String get pleaseLoginToTheWebVersionOfYourAccountFortunica {
    return Intl.message(
      'Please login to the web version of your account.',
      name: 'pleaseLoginToTheWebVersionOfYourAccountFortunica',
      desc: '',
      args: [],
    );
  }

  /// `You're currently offline`
  String get youReCurrentlyOfflineFortunica {
    return Intl.message(
      'You\'re currently offline',
      name: 'youReCurrentlyOfflineFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Change your status in your profile to make yourself visible to users.`
  String
      get changeYourStatusInYourProfileToMakeYourselfVisibleToUsersFortunica {
    return Intl.message(
      'Change your status in your profile to make yourself visible to users.',
      name:
          'changeYourStatusInYourProfileToMakeYourselfVisibleToUsersFortunica',
      desc: '',
      args: [],
    );
  }

  /// `TLeave a note when you'll be available again.`
  String get tellOurTeamWhenYouPlanToReturnFortunica {
    return Intl.message(
      'TLeave a note when you\'ll be available again.',
      name: 'tellOurTeamWhenYouPlanToReturnFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete this audio message?`
  String get doYouWantToDeleteThisAudioMessageFortunica {
    return Intl.message(
      'Do you want to delete this audio message?',
      name: 'doYouWantToDeleteThisAudioMessageFortunica',
      desc: '',
      args: [],
    );
  }

  /// `You don't have an internet connection`
  String get youDontHaveAnInternetConnectionFortunica {
    return Intl.message(
      'You don\'t have an internet connection',
      name: 'youDontHaveAnInternetConnectionFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Add any information you want to remember about this client.`
  String get addAnyInformationYouWantToRememberAboutThisClientFortunica {
    return Intl.message(
      'Add any information you want to remember about this client.',
      name: 'addAnyInformationYouWantToRememberAboutThisClientFortunica',
      desc: '',
      args: [],
    );
  }

  /// `You've reach the {maxRecordDurationInMinutes} minute time limit.`
  String youVeReachTheXMinuteTimeLimitFortunica(
      Object maxRecordDurationInMinutes) {
    return Intl.message(
      'You\'ve reach the $maxRecordDurationInMinutes minute time limit.',
      name: 'youVeReachTheXMinuteTimeLimitFortunica',
      desc: '',
      args: [maxRecordDurationInMinutes],
    );
  }

  /// `Preferred topics`
  String get preferredTopicsFortunica {
    return Intl.message(
      'Preferred topics',
      name: 'preferredTopicsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to return this question?`
  String get doYouWantToRejectThisQuestionFortunica {
    return Intl.message(
      'Do you want to return this question?',
      name: 'doYouWantToRejectThisQuestionFortunica',
      desc: '',
      args: [],
    );
  }

  /// `It will go back into the queue.`
  String get itWillGoBackIntoTheGeneralQueueFortunica {
    return Intl.message(
      'It will go back into the queue.',
      name: 'itWillGoBackIntoTheGeneralQueueFortunica',
      desc: '',
      args: [],
    );
  }

  /// `You must answer your active public question before you can help someone else.`
  String
      get youMustAnswerYourActivePublicQuestionBeforeYouCanHelpSomeoneElseFortunica {
    return Intl.message(
      'You must answer your active public question before you can help someone else.',
      name:
          'youMustAnswerYourActivePublicQuestionBeforeYouCanHelpSomeoneElseFortunica',
      desc: '',
      args: [],
    );
  }

  /// `RETURN\nTO QUEUE`
  String get returnToQueueFortunica {
    return Intl.message(
      'RETURN\nTO QUEUE',
      name: 'returnToQueueFortunica',
      desc: '',
      args: [],
    );
  }

  /// `No messages found with this filter.`
  String get noSessionsFoundWithThisFilterFortunica {
    return Intl.message(
      'No messages found with this filter.',
      name: 'noSessionsFoundWithThisFilterFortunica',
      desc: '',
      args: [],
    );
  }

  /// `When someone asks a quick question, you'll see it on this list`
  String get whenSomeoneAsksAPublicQuestionYouLlSeeThemOnThisListFortunica {
    return Intl.message(
      'When someone asks a quick question, you\'ll see it on this list',
      name: 'whenSomeoneAsksAPublicQuestionYouLlSeeThemOnThisListFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Use your new password to login`
  String get useYourNewPasswordToLoginFortunica {
    return Intl.message(
      'Use your new password to login',
      name: 'useYourNewPasswordToLoginFortunica',
      desc: '',
      args: [],
    );
  }

  /// `We've sent password reset instructions to {email}.`
  String weVeSentPasswordResetInstructionsToEmailFortunica(Object email) {
    return Intl.message(
      'We\'ve sent password reset instructions to $email.',
      name: 'weVeSentPasswordResetInstructionsToEmailFortunica',
      desc: '',
      args: [email],
    );
  }

  /// `Enter your email address and we'll send you instructions to create a new password`
  String
      get enterYourEmailAddressAndWeLlSendYouInstructionsToCreateANewPasswordFortunica {
    return Intl.message(
      'Enter your email address and we\'ll send you instructions to create a new password',
      name:
          'enterYourEmailAddressAndWeLlSendYouInstructionsToCreateANewPasswordFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Wrong email and/or password.`
  String get wrongUsernameAndOrPasswordFortunica {
    return Intl.message(
      'Wrong email and/or password.',
      name: 'wrongUsernameAndOrPasswordFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Type message`
  String get typeMessageFortunica {
    return Intl.message(
      'Type message',
      name: 'typeMessageFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm that your answer is ready to be sent`
  String get pleaseConfirmThatYourAnswerIsReadyToBeSentFortunica {
    return Intl.message(
      'Please confirm that your answer is ready to be sent',
      name: 'pleaseConfirmThatYourAnswerIsReadyToBeSentFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterYourPasswordFortunica {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPasswordFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterYourEmailFortunica {
    return Intl.message(
      'Enter your email',
      name: 'enterYourEmailFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password`
  String get enterNewPasswordFortunica {
    return Intl.message(
      'Enter new password',
      name: 'enterNewPasswordFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Repeat new password`
  String get repeatNewPasswordFortunica {
    return Intl.message(
      'Repeat new password',
      name: 'repeatNewPasswordFortunica',
      desc: '',
      args: [],
    );
  }

  /// `My Gallery`
  String get myGalleryFortunica {
    return Intl.message(
      'My Gallery',
      name: 'myGalleryFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Message is not sent`
  String get messageIsNotSentFortunica {
    return Intl.message(
      'Message is not sent',
      name: 'messageIsNotSentFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Recording is not possible, allocate space on the device`
  String get recordingIsNotPossibleAllocateSpaceOnTheDeviceFortunica {
    return Intl.message(
      'Recording is not possible, allocate space on the device',
      name: 'recordingIsNotPossibleAllocateSpaceOnTheDeviceFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Not specified`
  String get notSpecifiedFortunica {
    return Intl.message(
      'Not specified',
      name: 'notSpecifiedFortunica',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get newPasswordFortunica {
    return Intl.message(
      'New password',
      name: 'newPasswordFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Private Question`
  String get privateQuestionFortunica {
    return Intl.message(
      'Private Question',
      name: 'privateQuestionFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Quick Question`
  String get publicQuestionFortunica {
    return Intl.message(
      'Quick Question',
      name: 'publicQuestionFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Soulmate Reading`
  String get soulmateReadingSessionsFortunica {
    return Intl.message(
      'Soulmate Reading',
      name: 'soulmateReadingSessionsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Love Crush Reading`
  String get loveCrushReadingSessionsFortunica {
    return Intl.message(
      'Love Crush Reading',
      name: 'loveCrushReadingSessionsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Palm Reading`
  String get palmReadingSessionsFortunica {
    return Intl.message(
      'Palm Reading',
      name: 'palmReadingSessionsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `360° Reading`
  String get reading360SessionsFortunica {
    return Intl.message(
      '360° Reading',
      name: 'reading360SessionsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Ritual Session`
  String get ritualSessionsFortunica {
    return Intl.message(
      'Ritual Session',
      name: 'ritualSessionsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Astral Chart`
  String get astrologySessionsFortunica {
    return Intl.message(
      'Astral Chart',
      name: 'astrologySessionsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Card Reading`
  String get tarotSessionsFortunica {
    return Intl.message(
      'Card Reading',
      name: 'tarotSessionsFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get cancelledFortunica {
    return Intl.message(
      'Canceled',
      name: 'cancelledFortunica',
      desc: '',
      args: [],
    );
  }

  /// `Earned this month:`
  String get earnedThisMonthFortunica {
    return Intl.message(
      'Earned this month:',
      name: 'earnedThisMonthFortunica',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<SFortunica> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<SFortunica> load(Locale locale) => SFortunica.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
