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

class SZodiac {
  SZodiac();

  static SZodiac? _current;

  static SZodiac get current {
    assert(_current != null,
        'No instance of SZodiac was loaded. Try to initialize the SZodiac delegate before accessing SZodiac.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<SZodiac> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = SZodiac();
      SZodiac._current = instance;

      return instance;
    });
  }

  static SZodiac of(BuildContext context) {
    final instance = SZodiac.maybeOf(context);
    assert(instance != null,
        'No instance of SZodiac present in the widget tree. Did you add SZodiac.delegate in localizationsDelegates?');
    return instance!;
  }

  static SZodiac? maybeOf(BuildContext context) {
    return Localizations.of<SZodiac>(context, SZodiac);
  }

  /// `Check your internet connection`
  String get checkYourInternetConnectionZodiac {
    return Intl.message(
      'Check your internet connection',
      name: 'checkYourInternetConnectionZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgotPasswordZodiac {
    return Intl.message(
      'Forgot password',
      name: 'forgotPasswordZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailZodiac {
    return Intl.message(
      'Email',
      name: 'emailZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordZodiac {
    return Intl.message(
      'Password',
      name: 'passwordZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterYourPasswordZodiac {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPasswordZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterYourEmailZodiac {
    return Intl.message(
      'Enter your email',
      name: 'enterYourEmailZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginZodiac {
    return Intl.message(
      'Login',
      name: 'loginZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Choose email app`
  String get chooseEmailAppZodiac {
    return Intl.message(
      'Choose email app',
      name: 'chooseEmailAppZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Open email`
  String get openEmailZodiac {
    return Intl.message(
      'Open email',
      name: 'openEmailZodiac',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection.`
  String get noInternetConnectionZodiac {
    return Intl.message(
      'No internet connection.',
      name: 'noInternetConnectionZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Uh-oh. It looks like you've lost your connection. Please try again.`
  String get uhOhItLooksLikeYouVeLostYourConnectionPleaseTryAgainZodiac {
    return Intl.message(
      'Uh-oh. It looks like you\'ve lost your connection. Please try again.',
      name: 'uhOhItLooksLikeYouVeLostYourConnectionPleaseTryAgainZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelZodiac {
    return Intl.message(
      'Cancel',
      name: 'cancelZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Wrong username and/or password.`
  String get wrongUsernameAndOrPasswordZodiac {
    return Intl.message(
      'Wrong username and/or password.',
      name: 'wrongUsernameAndOrPasswordZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address and we'll send you instructions to create a new password`
  String
      get enterYourEmailAddressAndWeLlSendYouInstructionsToCreateANewPasswordZodiac {
    return Intl.message(
      'Enter your email address and we\'ll send you instructions to create a new password',
      name:
          'enterYourEmailAddressAndWeLlSendYouInstructionsToCreateANewPasswordZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetPasswordZodiac {
    return Intl.message(
      'Reset password',
      name: 'resetPasswordZodiac',
      desc: '',
      args: [],
    );
  }

  /// `We've sent password reset instructions to {email}.`
  String weVeSentPasswordResetInstructionsToEmailZodiac(Object email) {
    return Intl.message(
      'We\'ve sent password reset instructions to $email.',
      name: 'weVeSentPasswordResetInstructionsToEmailZodiac',
      desc: '',
      args: [email],
    );
  }

  /// `Dashboard`
  String get dashboardZodiac {
    return Intl.message(
      'Dashboard',
      name: 'dashboardZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get accountZodiac {
    return Intl.message(
      'Account',
      name: 'accountZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Articles`
  String get articlesZodiac {
    return Intl.message(
      'Articles',
      name: 'articlesZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Sessions`
  String get sessionsZodiac {
    return Intl.message(
      'Sessions',
      name: 'sessionsZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Your client session history will appear here`
  String get yourClientSessionHistoryWillAppearHereZodiac {
    return Intl.message(
      'Your client session history will appear here',
      name: 'yourClientSessionHistoryWillAppearHereZodiac',
      desc: '',
      args: [],
    );
  }

  /// `No sessions, yet.`
  String get noSessionsYetZodiac {
    return Intl.message(
      'No sessions, yet.',
      name: 'noSessionsYetZodiac',
      desc: '',
      args: [],
    );
  }

  /// `No articles, yet`
  String get noArticlesYet {
    return Intl.message(
      'No articles, yet',
      name: 'noArticlesYet',
      desc: '',
      args: [],
    );
  }

  /// `Here will appear articles`
  String get hereWillAppearArticles {
    return Intl.message(
      'Here will appear articles',
      name: 'hereWillAppearArticles',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get searchZodiac {
    return Intl.message(
      'Search',
      name: 'searchZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Avg Daily Earnings`
  String get avgDailyEarningsZodiac {
    return Intl.message(
      'Avg Daily Earnings',
      name: 'avgDailyEarningsZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Performance Overview Analytics`
  String get performanceOverviewAnalyticsZodiac {
    return Intl.message(
      'Performance Overview Analytics',
      name: 'performanceOverviewAnalyticsZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get todayZodiac {
    return Intl.message(
      'Today',
      name: 'todayZodiac',
      desc: '',
      args: [],
    );
  }

  /// `This Month`
  String get thisMonthZodiac {
    return Intl.message(
      'This Month',
      name: 'thisMonthZodiac',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get newZodiac {
    return Intl.message(
      'New',
      name: 'newZodiac',
      desc: '',
      args: [],
    );
  }

  /// `You can change price once per 24 h`
  String get youCanChangePriceOncePer24HZodiac {
    return Intl.message(
      'You can change price once per 24 h',
      name: 'youCanChangePriceOncePer24HZodiac',
      desc: '',
      args: [],
    );
  }

  /// `per minute`
  String get perMinuteZodiac {
    return Intl.message(
      'per minute',
      name: 'perMinuteZodiac',
      desc: '',
      args: [],
    );
  }

  /// `I'm available now`
  String get imAvailableNowZodiac {
    return Intl.message(
      'I\'m available now',
      name: 'imAvailableNowZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notificationsZodiac {
    return Intl.message(
      'Notifications',
      name: 'notificationsZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Preview account`
  String get previewAccountZodiac {
    return Intl.message(
      'Preview account',
      name: 'previewAccountZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviewsZodiac {
    return Intl.message(
      'Reviews',
      name: 'reviewsZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Balance & Transactions`
  String get balanceTransactionsZodiac {
    return Intl.message(
      'Balance & Transactions',
      name: 'balanceTransactionsZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumberZodiac {
    return Intl.message(
      'Phone number',
      name: 'phoneNumberZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Unverified`
  String get unverifiedZodiac {
    return Intl.message(
      'Unverified',
      name: 'unverifiedZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get addZodiac {
    return Intl.message(
      'Add',
      name: 'addZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Templates & Content`
  String get templatesContentZodiac {
    return Intl.message(
      'Templates & Content',
      name: 'templatesContentZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get servicesZodiac {
    return Intl.message(
      'Services',
      name: 'servicesZodiac',
      desc: '',
      args: [],
    );
  }

  /// `${price}/min`
  String pricePerMinZodiac(Object price) {
    return Intl.message(
      '\$$price/min',
      name: 'pricePerMinZodiac',
      desc: '',
      args: [price],
    );
  }

  /// `Change`
  String get changeZodiac {
    return Intl.message(
      'Change',
      name: 'changeZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Lowest rate`
  String get lowestRateZodiac {
    return Intl.message(
      'Lowest rate',
      name: 'lowestRateZodiac',
      desc: '',
      args: [],
    );
  }

  /// `New customers`
  String get newCustomersZodiac {
    return Intl.message(
      'New customers',
      name: 'newCustomersZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Sales`
  String get salesZodiac {
    return Intl.message(
      'Sales',
      name: 'salesZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Personal Balance:`
  String get personalBalanceZodiac {
    return Intl.message(
      'Personal Balance:',
      name: 'personalBalanceZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterdayZodiac {
    return Intl.message(
      'Yesterday',
      name: 'yesterdayZodiac',
      desc: '',
      args: [],
    );
  }

  /// `No notifications, yet`
  String get noNotificationsYetZodiac {
    return Intl.message(
      'No notifications, yet',
      name: 'noNotificationsYetZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Your notifications history will appear here`
  String get yourNotificationsHistoryWillAppearHereZodiac {
    return Intl.message(
      'Your notifications history will appear here',
      name: 'yourNotificationsHistoryWillAppearHereZodiac',
      desc: '',
      args: [],
    );
  }

  /// `No reviews, yet`
  String get noReviewsYetZodiac {
    return Intl.message(
      'No reviews, yet',
      name: 'noReviewsYetZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Reviews from your clients will appear here`
  String get reviewsFromYourClientsWillAppearHereZodiac {
    return Intl.message(
      'Reviews from your clients will appear here',
      name: 'reviewsFromYourClientsWillAppearHereZodiac',
      desc: '',
      args: [],
    );
  }

  /// `No transactions, yet`
  String get noTransactionsYetZodiac {
    return Intl.message(
      'No transactions, yet',
      name: 'noTransactionsYetZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Your transactions history will appear here`
  String get yourTransactionsHistoryWillAppearHereZodiac {
    return Intl.message(
      'Your transactions history will appear here',
      name: 'yourTransactionsHistoryWillAppearHereZodiac',
      desc: '',
      args: [],
    );
  }

  /// `😱 Oops! Your login details seem to be incorrect. Give it another try, or tap Reset Password.`
  String
      get oopsYourLoginDetailsSeemToBeIncorrectGiveItAnotherTryOrTapResetPasswordZodiac {
    return Intl.message(
      '😱 Oops! Your login details seem to be incorrect. Give it another try, or tap Reset Password.',
      name:
          'oopsYourLoginDetailsSeemToBeIncorrectGiveItAnotherTryOrTapResetPasswordZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Zodiac Team`
  String get zodiacTeam {
    return Intl.message(
      'Zodiac Team',
      name: 'zodiacTeam',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been blocked.<br>Please contact <a href=''>Customer Support</a> to resolve the issue`
  String get youWereBlocked {
    return Intl.message(
      'Your account has been blocked.<br>Please contact <a href=\'\'>Customer Support</a> to resolve the issue',
      name: 'youWereBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Customer Support`
  String get customerSupportZodiac {
    return Intl.message(
      'Customer Support',
      name: 'customerSupportZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get editProfileZodiac {
    return Intl.message(
      'Edit profile',
      name: 'editProfileZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to delete {localeName} from your list?`
  String doYouReallyWantToDeleteLocaleNameFromYourListZodiac(
      Object localeName) {
    return Intl.message(
      'Do you really want to delete $localeName from your list?',
      name: 'doYouReallyWantToDeleteLocaleNameFromYourListZodiac',
      desc: '',
      args: [localeName],
    );
  }

  /// `Nickname`
  String get nicknameZodiac {
    return Intl.message(
      'Nickname',
      name: 'nicknameZodiac',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get aboutZodiac {
    return Intl.message(
      'About',
      name: 'aboutZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Experience`
  String get experienceZodiac {
    return Intl.message(
      'Experience',
      name: 'experienceZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Chat start greeting`
  String get chatStartGreetingZodiac {
    return Intl.message(
      'Chat start greeting',
      name: 'chatStartGreetingZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Main language`
  String get mainLanguageZodiac {
    return Intl.message(
      'Main language',
      name: 'mainLanguageZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Main specialty`
  String get mainSpecialtyZodiac {
    return Intl.message(
      'Main specialty',
      name: 'mainSpecialtyZodiac',
      desc: '',
      args: [],
    );
  }

  /// `My specialties`
  String get mySpecialtiesZodiac {
    return Intl.message(
      'My specialties',
      name: 'mySpecialtiesZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Your changes are accepted and will be reviewed shortly. All updates will be visible to clients after that`
  String get yourChangesAreAcceptedAndWillBeReviewedShortlyZodiac {
    return Intl.message(
      'Your changes are accepted and will be reviewed shortly. All updates will be visible to clients after that',
      name: 'yourChangesAreAcceptedAndWillBeReviewedShortlyZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get saveZodiac {
    return Intl.message(
      'Save',
      name: 'saveZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get closeZodiac {
    return Intl.message(
      'Close',
      name: 'closeZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get languageZodiac {
    return Intl.message(
      'Language',
      name: 'languageZodiac',
      desc: '',
      args: [],
    );
  }

  /// `All specialities`
  String get allSpecialitiesZodiac {
    return Intl.message(
      'All specialities',
      name: 'allSpecialitiesZodiac',
      desc: '',
      args: [],
    );
  }

  /// `The nickname is invalid. Must be 3 to 250 symbols.`
  String get theNicknameIsInvalidMustBe3to250SymbolsZodiac {
    return Intl.message(
      'The nickname is invalid. Must be 3 to 250 symbols.',
      name: 'theNicknameIsInvalidMustBe3to250SymbolsZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Character limit exceeded.`
  String get characterLimitExceededZodiac {
    return Intl.message(
      'Character limit exceeded.',
      name: 'characterLimitExceededZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Required field`
  String get requiredFieldZodiac {
    return Intl.message(
      'Required field',
      name: 'requiredFieldZodiac',
      desc: '',
      args: [],
    );
  }

  /// `The passwords must match`
  String get thePasswordsMustMatchZodiac {
    return Intl.message(
      'The passwords must match',
      name: 'thePasswordsMustMatchZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Please enter at least 8 characters`
  String get pleaseEnterAtLeast8CharactersZodiac {
    return Intl.message(
      'Please enter at least 8 characters',
      name: 'pleaseEnterAtLeast8CharactersZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Please, insert correct email`
  String get pleaseInsertCorrectEmailZodiac {
    return Intl.message(
      'Please, insert correct email',
      name: 'pleaseInsertCorrectEmailZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Top Up`
  String get topUpZodiac {
    return Intl.message(
      'Top Up',
      name: 'topUpZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Chat:`
  String get chatZodiac {
    return Intl.message(
      'Chat:',
      name: 'chatZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Call:`
  String get callZodiac {
    return Intl.message(
      'Call:',
      name: 'callZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Bonus`
  String get bonusZodiac {
    return Intl.message(
      'Bonus',
      name: 'bonusZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Return`
  String get returnZodiac {
    return Intl.message(
      'Return',
      name: 'returnZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Tip`
  String get tipZodiac {
    return Intl.message(
      'Tip',
      name: 'tipZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Service`
  String get serviceZodiac {
    return Intl.message(
      'Service',
      name: 'serviceZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal`
  String get withdrawalZodiac {
    return Intl.message(
      'Withdrawal',
      name: 'withdrawalZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Online services:`
  String get onlineServicesZodiac {
    return Intl.message(
      'Online services:',
      name: 'onlineServicesZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Offline service:`
  String get offlineServiceZodiac {
    return Intl.message(
      'Offline service:',
      name: 'offlineServiceZodiac',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get daysZodiac {
    return Intl.message(
      'days',
      name: 'daysZodiac',
      desc: '',
      args: [],
    );
  }

  /// `hours`
  String get hoursZodiac {
    return Intl.message(
      'hours',
      name: 'hoursZodiac',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get minutesZodiac {
    return Intl.message(
      'min',
      name: 'minutesZodiac',
      desc: '',
      args: [],
    );
  }

  /// `sec`
  String get secondsZodiac {
    return Intl.message(
      'sec',
      name: 'secondsZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your country code and enter your phone number`
  String get confirmYourCountryCodeAndEnterYourPhoneNumberZodiac {
    return Intl.message(
      'Confirm your country code and enter your phone number',
      name: 'confirmYourCountryCodeAndEnterYourPhoneNumberZodiac',
      desc: '',
      args: [],
    );
  }

  /// `We’ll text you a code to verify your phone number`
  String get wellTextYouCodeToVerifyYourPhoneNumberZodiac {
    return Intl.message(
      'We’ll text you a code to verify your phone number',
      name: 'wellTextYouCodeToVerifyYourPhoneNumberZodiac',
      desc: '',
      args: [],
    );
  }

  /// `You have {attempts} verification attempts per day`
  String youHaveVerificationAttemptsPerDayZodiac(Object attempts) {
    return Intl.message(
      'You have $attempts verification attempts per day',
      name: 'youHaveVerificationAttemptsPerDayZodiac',
      desc: '',
      args: [attempts],
    );
  }

  /// `Code`
  String get codeZodiac {
    return Intl.message(
      'Code',
      name: 'codeZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phoneZodiac {
    return Intl.message(
      'Phone',
      name: 'phoneZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Send code`
  String get sendCodeZodiac {
    return Intl.message(
      'Send code',
      name: 'sendCodeZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect code`
  String get incorrectCodeZodiac {
    return Intl.message(
      'Incorrect code',
      name: 'incorrectCodeZodiac',
      desc: '',
      args: [],
    );
  }

  /// `SMS verification`
  String get SMSverificationZodiac {
    return Intl.message(
      'SMS verification',
      name: 'SMSverificationZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Please type the verification code sent to \n {phoneNumber}`
  String pleaseTypeTheVerificationCodeZodiac(Object phoneNumber) {
    return Intl.message(
      'Please type the verification code sent to \n $phoneNumber',
      name: 'pleaseTypeTheVerificationCodeZodiac',
      desc: '',
      args: [phoneNumber],
    );
  }

  /// `You have {attempts} attempts to enter the right code`
  String youHaveAttemptsToEnterRightCodeZodiac(Object attempts) {
    return Intl.message(
      'You have $attempts attempts to enter the right code',
      name: 'youHaveAttemptsToEnterRightCodeZodiac',
      desc: '',
      args: [attempts],
    );
  }

  /// `Verify`
  String get verifyZodiac {
    return Intl.message(
      'Verify',
      name: 'verifyZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Resend code {attempts}`
  String resendCodeZodiac(Object attempts) {
    return Intl.message(
      'Resend code $attempts',
      name: 'resendCodeZodiac',
      desc: '',
      args: [attempts],
    );
  }

  /// `Next attempt in {seconds}s`
  String nextAttemptInZodiac(Object seconds) {
    return Intl.message(
      'Next attempt in ${seconds}s',
      name: 'nextAttemptInZodiac',
      desc: '',
      args: [seconds],
    );
  }

  /// `Phone number verified`
  String get phoneNumberVerifiedZodiac {
    return Intl.message(
      'Phone number verified',
      name: 'phoneNumberVerifiedZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Now you can receive calls`
  String get nowYouCanReceiveCallsZodiac {
    return Intl.message(
      'Now you can receive calls',
      name: 'nowYouCanReceiveCallsZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get gotItZodiac {
    return Intl.message(
      'Got it',
      name: 'gotItZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get successZodiac {
    return Intl.message(
      'Success',
      name: 'successZodiac',
      desc: '',
      args: [],
    );
  }

  /// `We’ve sent you a new code`
  String get weveSentYouNewCodeZodiac {
    return Intl.message(
      'We’ve sent you a new code',
      name: 'weveSentYouNewCodeZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get okZodiac {
    return Intl.message(
      'Ok',
      name: 'okZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Limit reached`
  String get limitReachedZodiac {
    return Intl.message(
      'Limit reached',
      name: 'limitReachedZodiac',
      desc: '',
      args: [],
    );
  }

  /// `You’ve reached the limit of phone verification attempts. Please contact support.`
  String get youveReachedLimitPhoneVerificationAttemptsZodiac {
    return Intl.message(
      'You’ve reached the limit of phone verification attempts. Please contact support.',
      name: 'youveReachedLimitPhoneVerificationAttemptsZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Start Chat`
  String get startChatZodiac {
    return Intl.message(
      'Start Chat',
      name: 'startChatZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Decline`
  String get declineZodiac {
    return Intl.message(
      'Decline',
      name: 'declineZodiac',
      desc: '',
      args: [],
    );
  }

  /// `INCOMING Chat`
  String get incomingChatZodiac {
    return Intl.message(
      'INCOMING Chat',
      name: 'incomingChatZodiac',
      desc: '',
      args: [],
    );
  }

  /// `You missed call\n from {clientName}.`
  String youMissedCallFromZodiac(Object clientName) {
    return Intl.message(
      'You missed call\n from $clientName.',
      name: 'youMissedCallFromZodiac',
      desc: '',
      args: [clientName],
    );
  }

  /// `You missed chat \n from {clientName}.`
  String youMissedChatFromZodiac(Object clientName) {
    return Intl.message(
      'You missed chat \n from $clientName.',
      name: 'youMissedChatFromZodiac',
      desc: '',
      args: [clientName],
    );
  }

  /// `Reply`
  String get replyZodiac {
    return Intl.message(
      'Reply',
      name: 'replyZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Chat started`
  String get chatStartedZodiac {
    return Intl.message(
      'Chat started',
      name: 'chatStartedZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Chat ended`
  String get chatEndedZodiac {
    return Intl.message(
      'Chat ended',
      name: 'chatEndedZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Call started`
  String get callStartedZodiac {
    return Intl.message(
      'Call started',
      name: 'callStartedZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Call ended`
  String get callEndedZodiac {
    return Intl.message(
      'Call ended',
      name: 'callEndedZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Hide chat`
  String get hideChatZodiac {
    return Intl.message(
      'Hide chat',
      name: 'hideChatZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Preferred language: `
  String get preferredLanguageZodiac {
    return Intl.message(
      'Preferred language: ',
      name: 'preferredLanguageZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Freebie seeker`
  String get freebieSeeker {
    return Intl.message(
      'Freebie seeker',
      name: 'freebieSeeker',
      desc: '',
      args: [],
    );
  }

  /// `Type message`
  String get typeMessageZodiac {
    return Intl.message(
      'Type message',
      name: 'typeMessageZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Selected photo`
  String get selectedPhotoZodiac {
    return Intl.message(
      'Selected photo',
      name: 'selectedPhotoZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Reconnecting...`
  String get reconnectingZodiac {
    return Intl.message(
      'Reconnecting...',
      name: 'reconnectingZodiac',
      desc: '',
      args: [],
    );
  }

  /// `End\nchat`
  String get endChatZodiac {
    return Intl.message(
      'End\nchat',
      name: 'endChatZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to end the chat?`
  String get doYouReallyWantToEndTheChatZodiac {
    return Intl.message(
      'Do you really want to end the chat?',
      name: 'doYouReallyWantToEndTheChatZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yesZodiac {
    return Intl.message(
      'Yes',
      name: 'yesZodiac',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get noZodiac {
    return Intl.message(
      'No',
      name: 'noZodiac',
      desc: '',
      args: [],
    );
  }

  /// `You are able to write within {timer}`
  String youAreAbleToWriteWithinZodiac(Object timer) {
    return Intl.message(
      'You are able to write within $timer',
      name: 'youAreAbleToWriteWithinZodiac',
      desc: '',
      args: [timer],
    );
  }

  /// `Report underage user`
  String get reportUnderageUserZodiac {
    return Intl.message(
      'Report underage user',
      name: 'reportUnderageUserZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get reportZodiac {
    return Intl.message(
      'Report',
      name: 'reportZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to close the chat?`
  String get doYouReallyWantToCloseTheChatZodiac {
    return Intl.message(
      'Do you really want to close the chat?',
      name: 'doYouReallyWantToCloseTheChatZodiac',
      desc: '',
      args: [],
    );
  }

  /// `Audio message`
  String get audioMessageZodiac {
    return Intl.message(
      'Audio message',
      name: 'audioMessageZodiac',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<SZodiac> {
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
  Future<SZodiac> load(Locale locale) => SZodiac.load(locale);
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
