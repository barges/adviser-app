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

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgotPassword {
    return Intl.message(
      'Forgot password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm new password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `The passwords must match`
  String get thePasswordsMustMatch {
    return Intl.message(
      'The passwords must match',
      name: 'thePasswordsMustMatch',
      desc: '',
      args: [],
    );
  }

  /// `Please enter at least 6 characters`
  String get pleaseEnterAtLeast6Characters {
    return Intl.message(
      'Please enter at least 6 characters',
      name: 'pleaseEnterAtLeast6Characters',
      desc: '',
      args: [],
    );
  }

  /// `Please, insert correct email`
  String get pleaseInsertCorrectEmail {
    return Intl.message(
      'Please, insert correct email',
      name: 'pleaseInsertCorrectEmail',
      desc: '',
      args: [],
    );
  }

  /// `Choose brand`
  String get chooseBrand {
    return Intl.message(
      'Choose brand',
      name: 'chooseBrand',
      desc: '',
      args: [],
    );
  }

  /// `Coming soon!`
  String get comingSoon {
    return Intl.message(
      'Coming soon!',
      name: 'comingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password`
  String get forgotYourPassword {
    return Intl.message(
      'Forgot your password',
      name: 'forgotYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Request new password`
  String get requestNewPassword {
    return Intl.message(
      'Request new password',
      name: 'requestNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `The user was not found`
  String get theUserWasNotFound {
    return Intl.message(
      'The user was not found',
      name: 'theUserWasNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get editProfile {
    return Intl.message(
      'Edit profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Add cover picture`
  String get addCoverPicture {
    return Intl.message(
      'Add cover picture',
      name: 'addCoverPicture',
      desc: '',
      args: [],
    );
  }

  /// `Change photo`
  String get changePhoto {
    return Intl.message(
      'Change photo',
      name: 'changePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Nickname`
  String get nickname {
    return Intl.message(
      'Nickname',
      name: 'nickname',
      desc: '',
      args: [],
    );
  }

  /// `Name can be changed only on Advisor Tool`
  String get nameCanBeChangedOnlyOnAdvisorTool {
    return Intl.message(
      'Name can be changed only on Advisor Tool',
      name: 'nameCanBeChangedOnlyOnAdvisorTool',
      desc: '',
      args: [],
    );
  }

  /// `Status Text`
  String get statusText {
    return Intl.message(
      'Status Text',
      name: 'statusText',
      desc: '',
      args: [],
    );
  }

  /// `Profile Text`
  String get profileText {
    return Intl.message(
      'Profile Text',
      name: 'profileText',
      desc: '',
      args: [],
    );
  }

  /// `Add Gallery Pictures`
  String get addGalleryPictures {
    return Intl.message(
      'Add Gallery Pictures',
      name: 'addGalleryPictures',
      desc: '',
      args: [],
    );
  }

  /// `Add more`
  String get addMore {
    return Intl.message(
      'Add more',
      name: 'addMore',
      desc: '',
      args: [],
    );
  }

  /// `Workspaces`
  String get workspaces {
    return Intl.message(
      'Workspaces',
      name: 'workspaces',
      desc: '',
      args: [],
    );
  }

  /// `Other brands`
  String get otherBrands {
    return Intl.message(
      'Other brands',
      name: 'otherBrands',
      desc: '',
      args: [],
    );
  }

  /// `All brands`
  String get allOurBrands {
    return Intl.message(
      'All brands',
      name: 'allOurBrands',
      desc: '',
      args: [],
    );
  }

  /// `Customer Support`
  String get customerSupport {
    return Intl.message(
      'Customer Support',
      name: 'customerSupport',
      desc: '',
      args: [],
    );
  }

  /// `We pride ourselves to offer advisors  a safe place to serve customers and develop professionally. Doing a good job in one of our brands will open doors to others`
  String get wePrideOurselvesToOfferAdvisorsASafePlaceTo {
    return Intl.message(
      'We pride ourselves to offer advisors  a safe place to serve customers and develop professionally. Doing a good job in one of our brands will open doors to others',
      name: 'wePrideOurselvesToOfferAdvisorsASafePlaceTo',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Cancel sending`
  String get cancelSending {
    return Intl.message(
      'Cancel sending',
      name: 'cancelSending',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Ingenio`
  String get ingenio {
    return Intl.message(
      'Ingenio',
      name: 'ingenio',
      desc: '',
      args: [],
    );
  }

  /// `Choose email app`
  String get chooseEmailApp {
    return Intl.message(
      'Choose email app',
      name: 'chooseEmailApp',
      desc: '',
      args: [],
    );
  }

  /// `Public`
  String get public {
    return Intl.message(
      'Public',
      name: 'public',
      desc: '',
      args: [],
    );
  }

  /// `For me`
  String get forMe {
    return Intl.message(
      'For me',
      name: 'forMe',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `I'm available now`
  String get imAvailableNow {
    return Intl.message(
      'I\'m available now',
      name: 'imAvailableNow',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Preview account`
  String get previewAccount {
    return Intl.message(
      'Preview account',
      name: 'previewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviews {
    return Intl.message(
      'Reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `Balance & Transactions`
  String get balanceTransactions {
    return Intl.message(
      'Balance & Transactions',
      name: 'balanceTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Not enough conversations? Check our Profile Guide.`
  String get notEnoughConversationsCheckOurProfileGuide {
    return Intl.message(
      'Not enough conversations? Check our Profile Guide.',
      name: 'notEnoughConversationsCheckOurProfileGuide',
      desc: '',
      args: [],
    );
  }

  /// `See more`
  String get seeMore {
    return Intl.message(
      'See more',
      name: 'seeMore',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get newLabel {
    return Intl.message(
      'New',
      name: 'newLabel',
      desc: '',
      args: [],
    );
  }

  /// `Mandatory`
  String get mandatory {
    return Intl.message(
      'Mandatory',
      name: 'mandatory',
      desc: '',
      args: [],
    );
  }

  /// `Articles`
  String get articles {
    return Intl.message(
      'Articles',
      name: 'articles',
      desc: '',
      args: [],
    );
  }

  /// `New mandatory article is available!`
  String get newMandatoryArticleIsAvailable {
    return Intl.message(
      'New mandatory article is available!',
      name: 'newMandatoryArticleIsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `You have {count} days to read it before your account will get blocked!`
  String youHaveXdaystoReadItBeforeYourAccountWillGetBlocked(Object count) {
    return Intl.message(
      'You have $count days to read it before your account will get blocked!',
      name: 'youHaveXdaystoReadItBeforeYourAccountWillGetBlocked',
      desc: '',
      args: [count],
    );
  }

  /// `Take me there`
  String get takeMeThere {
    return Intl.message(
      'Take me there',
      name: 'takeMeThere',
      desc: '',
      args: [],
    );
  }

  /// `Change cover picture`
  String get changeCoverPicture {
    return Intl.message(
      'Change cover picture',
      name: 'changeCoverPicture',
      desc: '',
      args: [],
    );
  }

  /// `Please enter at least 3 characters`
  String get pleaseEnterAtLeast3Characters {
    return Intl.message(
      'Please enter at least 3 characters',
      name: 'pleaseEnterAtLeast3Characters',
      desc: '',
      args: [],
    );
  }

  /// `Resources`
  String get resources {
    return Intl.message(
      'Resources',
      name: 'resources',
      desc: '',
      args: [],
    );
  }

  /// `Stats`
  String get stats {
    return Intl.message(
      'Stats',
      name: 'stats',
      desc: '',
      args: [],
    );
  }

  /// `Courses`
  String get courses {
    return Intl.message(
      'Courses',
      name: 'courses',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `This Week`
  String get thisWeek {
    return Intl.message(
      'This Week',
      name: 'thisWeek',
      desc: '',
      args: [],
    );
  }

  /// `This Month`
  String get thisMonth {
    return Intl.message(
      'This Month',
      name: 'thisMonth',
      desc: '',
      args: [],
    );
  }

  /// `Customers`
  String get customers {
    return Intl.message(
      'Customers',
      name: 'customers',
      desc: '',
      args: [],
    );
  }

  /// `Customers who come back to you after buying the first session on any platform`
  String get customersComeBackToYouAfterBuyingFirstSessionPlatform {
    return Intl.message(
      'Customers who come back to you after buying the first session on any platform',
      name: 'customersComeBackToYouAfterBuyingFirstSessionPlatform',
      desc: '',
      args: [],
    );
  }

  /// `New Users`
  String get newUsers {
    return Intl.message(
      'New Users',
      name: 'newUsers',
      desc: '',
      args: [],
    );
  }

  /// `Loyal Users`
  String get loyalUsers {
    return Intl.message(
      'Loyal Users',
      name: 'loyalUsers',
      desc: '',
      args: [],
    );
  }

  /// `Similar articles`
  String get similarArticles {
    return Intl.message(
      'Similar articles',
      name: 'similarArticles',
      desc: '',
      args: [],
    );
  }

  /// `Take a photo`
  String get takeAPhoto {
    return Intl.message(
      'Take a photo',
      name: 'takeAPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Will be available in`
  String get willBeAvailableIn {
    return Intl.message(
      'Will be available in',
      name: 'willBeAvailableIn',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure that you want to change your status to Offline?`
  String get areYouSureThatYouWantToChangeYourStatus {
    return Intl.message(
      'Are you sure that you want to change your status to Offline?',
      name: 'areYouSureThatYouWantToChangeYourStatus',
      desc: '',
      args: [],
    );
  }

  /// `Yes, I’m sure`
  String get yesImSure {
    return Intl.message(
      'Yes, I’m sure',
      name: 'yesImSure',
      desc: '',
      args: [],
    );
  }

  /// `No, I changed my mind`
  String get noIChangedMyMind {
    return Intl.message(
      'No, I changed my mind',
      name: 'noIChangedMyMind',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Earned`
  String get earned {
    return Intl.message(
      'Earned',
      name: 'earned',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Total markets`
  String get totalMarkets {
    return Intl.message(
      'Total markets',
      name: 'totalMarkets',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message(
      'Dashboard',
      name: 'dashboard',
      desc: '',
      args: [],
    );
  }

  /// `About Me`
  String get aboutMe {
    return Intl.message(
      'About Me',
      name: 'aboutMe',
      desc: '',
      args: [],
    );
  }

  /// `Quick Answers`
  String get quickAnswers {
    return Intl.message(
      'Quick Answers',
      name: 'quickAnswers',
      desc: '',
      args: [],
    );
  }

  /// `Born`
  String get born {
    return Intl.message(
      'Born',
      name: 'born',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message(
      'Chats',
      name: 'chats',
      desc: '',
      args: [],
    );
  }

  /// `Calls`
  String get calls {
    return Intl.message(
      'Calls',
      name: 'calls',
      desc: '',
      args: [],
    );
  }

  /// `services`
  String get services {
    return Intl.message(
      'services',
      name: 'services',
      desc: '',
      args: [],
    );
  }

  /// `Add new`
  String get addNew {
    return Intl.message(
      'Add new',
      name: 'addNew',
      desc: '',
      args: [],
    );
  }

  /// `You don’t have any notes yet`
  String get youDoNotHaveAnyNotesYet {
    return Intl.message(
      'You don’t have any notes yet',
      name: 'youDoNotHaveAnyNotesYet',
      desc: '',
      args: [],
    );
  }

  /// `Add Note`
  String get addNote {
    return Intl.message(
      'Add Note',
      name: 'addNote',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `You have not completed any sessions yet`
  String get youHaveNotCompletedAnySessionsYet {
    return Intl.message(
      'You have not completed any sessions yet',
      name: 'youHaveNotCompletedAnySessionsYet',
      desc: '',
      args: [],
    );
  }

  /// `You have not yet completed this month's sessions`
  String get youHaveNotYetCompletedThisMonthsSessions {
    return Intl.message(
      'You have not yet completed this month\'s sessions',
      name: 'youHaveNotYetCompletedThisMonthsSessions',
      desc: '',
      args: [],
    );
  }

  /// `Avg Daily Earnings`
  String get avgDailyEarnings {
    return Intl.message(
      'Avg Daily Earnings',
      name: 'avgDailyEarnings',
      desc: '',
      args: [],
    );
  }

  /// `Perfomance Overview Analytics`
  String get perfomanceOverviewAnalytics {
    return Intl.message(
      'Perfomance Overview Analytics',
      name: 'perfomanceOverviewAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Edit Note`
  String get editNote {
    return Intl.message(
      'Edit Note',
      name: 'editNote',
      desc: '',
      args: [],
    );
  }

  /// `All Markets`
  String get allMarkets {
    return Intl.message(
      'All Markets',
      name: 'allMarkets',
      desc: '',
      args: [],
    );
  }

  /// `Market:`
  String get market {
    return Intl.message(
      'Market:',
      name: 'market',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Private Questions`
  String get privateQuestions {
    return Intl.message(
      'Private Questions',
      name: 'privateQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Only Premium Products`
  String get onlyPremiumProducts {
    return Intl.message(
      'Only Premium Products',
      name: 'onlyPremiumProducts',
      desc: '',
      args: [],
    );
  }

  /// `No questions, yet.`
  String get noQuestionsYet {
    return Intl.message(
      'No questions, yet.',
      name: 'noQuestionsYet',
      desc: '',
      args: [],
    );
  }

  /// `No sessions, yet.`
  String get noSessionsYet {
    return Intl.message(
      'No sessions, yet.',
      name: 'noSessionsYet',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection.`
  String get noInternetConnection {
    return Intl.message(
      'No internet connection.',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `You will be able to change your status back in 1 hour`
  String get youWillBeAbleToChangeYourStatusBackIn {
    return Intl.message(
      'You will be able to change your status back in 1 hour',
      name: 'youWillBeAbleToChangeYourStatusBackIn',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetPassword {
    return Intl.message(
      'Reset password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been blocked. Please contact your advisor manager.`
  String get yourAccountHasBeenBlockedPleaseContactYourAdvisorManager {
    return Intl.message(
      'Your account has been blocked. Please contact your advisor manager.',
      name: 'yourAccountHasBeenBlockedPleaseContactYourAdvisorManager',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Sessions`
  String get sessions {
    return Intl.message(
      'Sessions',
      name: 'sessions',
      desc: '',
      args: [],
    );
  }

  /// `from {minRecordDurationInSec} sec to {maxRecordDurationInMinutes} min`
  String fromXsecToYmin(
      Object minRecordDurationInSec, Object maxRecordDurationInMinutes) {
    return Intl.message(
      'from $minRecordDurationInSec sec to $maxRecordDurationInMinutes min',
      name: 'fromXsecToYmin',
      desc: '',
      args: [minRecordDurationInSec, maxRecordDurationInMinutes],
    );
  }

  /// `Do you want to delete image?`
  String get doYouWantToDeleteImage {
    return Intl.message(
      'Do you want to delete image?',
      name: 'doYouWantToDeleteImage',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get tryAgain {
    return Intl.message(
      'Try again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Return`
  String get return_ {
    return Intl.message(
      'Return',
      name: 'return_',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Live`
  String get live {
    return Intl.message(
      'Live',
      name: 'live',
      desc: '',
      args: [],
    );
  }

  /// `Incomplete`
  String get incomplete {
    return Intl.message(
      'Incomplete',
      name: 'incomplete',
      desc: '',
      args: [],
    );
  }

  /// `Blocked`
  String get blocked {
    return Intl.message(
      'Blocked',
      name: 'blocked',
      desc: '',
      args: [],
    );
  }

  /// `Legal block`
  String get legalBlock {
    return Intl.message(
      'Legal block',
      name: 'legalBlock',
      desc: '',
      args: [],
    );
  }

  /// `Offline`
  String get offline {
    return Intl.message(
      'Offline',
      name: 'offline',
      desc: '',
      args: [],
    );
  }

  /// `Go to Account`
  String get goToAccount {
    return Intl.message(
      'Go to Account',
      name: 'goToAccount',
      desc: '',
      args: [],
    );
  }

  /// `Active chat`
  String get activeChat {
    return Intl.message(
      'Active chat',
      name: 'activeChat',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `PERSONAL DETAILS`
  String get personalDetails {
    return Intl.message(
      'PERSONAL DETAILS',
      name: 'personalDetails',
      desc: '',
      args: [],
    );
  }

  /// `Take question`
  String get takeQuestion {
    return Intl.message(
      'Take question',
      name: 'takeQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Photo is required`
  String get photoIsRequired {
    return Intl.message(
      'Photo is required',
      name: 'photoIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Your Username`
  String get yourUsername {
    return Intl.message(
      'Your Username',
      name: 'yourUsername',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Non-binary`
  String get nonBinary {
    return Intl.message(
      'Non-binary',
      name: 'nonBinary',
      desc: '',
      args: [],
    );
  }

  /// `Prefer not to answer`
  String get preferNotToAnswer {
    return Intl.message(
      'Prefer not to answer',
      name: 'preferNotToAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Audio message`
  String get audioMessage {
    return Intl.message(
      'Audio message',
      name: 'audioMessage',
      desc: '',
      args: [],
    );
  }

  /// `We didn’t find anything`
  String get weDidntFindAnything {
    return Intl.message(
      'We didn’t find anything',
      name: 'weDidntFindAnything',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Private`
  String get private {
    return Intl.message(
      'Private',
      name: 'private',
      desc: '',
      args: [],
    );
  }

  /// `Tarot`
  String get tarot {
    return Intl.message(
      'Tarot',
      name: 'tarot',
      desc: '',
      args: [],
    );
  }

  /// `Palm Reading`
  String get palmReading {
    return Intl.message(
      'Palm Reading',
      name: 'palmReading',
      desc: '',
      args: [],
    );
  }

  /// `Astrology`
  String get astrology {
    return Intl.message(
      'Astrology',
      name: 'astrology',
      desc: '',
      args: [],
    );
  }

  /// `360° Reading`
  String get reading360 {
    return Intl.message(
      '360° Reading',
      name: 'reading360',
      desc: '',
      args: [],
    );
  }

  /// `Soulmate Reading`
  String get soulmateReading {
    return Intl.message(
      'Soulmate Reading',
      name: 'soulmateReading',
      desc: '',
      args: [],
    );
  }

  /// `Love Crush Reading`
  String get loveCrushReading {
    return Intl.message(
      'Love Crush Reading',
      name: 'loveCrushReading',
      desc: '',
      args: [],
    );
  }

  /// `Ritual`
  String get ritual {
    return Intl.message(
      'Ritual',
      name: 'ritual',
      desc: '',
      args: [],
    );
  }

  /// `Tips`
  String get tips {
    return Intl.message(
      'Tips',
      name: 'tips',
      desc: '',
      args: [],
    );
  }

  /// `Questions`
  String get questions {
    return Intl.message(
      'Questions',
      name: 'questions',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question {
    return Intl.message(
      'Question',
      name: 'question',
      desc: '',
      args: [],
    );
  }

  /// `Session`
  String get session {
    return Intl.message(
      'Session',
      name: 'session',
      desc: '',
      args: [],
    );
  }

  /// `Check your internet connection`
  String get checkYourInternetConnection {
    return Intl.message(
      'Check your internet connection',
      name: 'checkYourInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `You can’t send this message because it’s less than {minRecordDurationInSec} seconds`
  String youCantSendThisMessageBecauseItsLessThanXSeconds(
      Object minRecordDurationInSec) {
    return Intl.message(
      'You can’t send this message because it’s less than $minRecordDurationInSec seconds',
      name: 'youCantSendThisMessageBecauseItsLessThanXSeconds',
      desc: '',
      args: [minRecordDurationInSec],
    );
  }

  /// `The maximum size of the attachments is {maxAttachmentSizeInMb}Mb`
  String theMaximumSizeOfTheAttachmentsIsXMb(Object maxAttachmentSizeInMb) {
    return Intl.message(
      'The maximum size of the attachments is ${maxAttachmentSizeInMb}Mb',
      name: 'theMaximumSizeOfTheAttachmentsIsXMb',
      desc: '',
      args: [maxAttachmentSizeInMb],
    );
  }

  /// `This question will be returned to the general list after {counter}`
  String thisQuestionWillBeReturnedToTheGeneralListAfterCounter(
      Object counter) {
    return Intl.message(
      'This question will be returned to the general list after $counter',
      name: 'thisQuestionWillBeReturnedToTheGeneralListAfterCounter',
      desc: '',
      args: [counter],
    );
  }

  /// `The answer is not possible, this question will be returned to the general list in ~ 1m`
  String
      get theAnswerIsNotPossibleThisQuestionWillBeReturnedToTheGeneralListIn1m {
    return Intl.message(
      'The answer is not possible, this question will be returned to the general list in ~ 1m',
      name:
          'theAnswerIsNotPossibleThisQuestionWillBeReturnedToTheGeneralListIn1m',
      desc: '',
      args: [],
    );
  }

  /// `You have an active session`
  String get youHaveAnActiveSession {
    return Intl.message(
      'You have an active session',
      name: 'youHaveAnActiveSession',
      desc: '',
      args: [],
    );
  }

  /// `You have a private message`
  String get youHaveAPrivateMessage {
    return Intl.message(
      'You have a private message',
      name: 'youHaveAPrivateMessage',
      desc: '',
      args: [],
    );
  }

  /// `You have a few active sessions`
  String get youHaveAFewActiveSessions {
    return Intl.message(
      'You have a few active sessions',
      name: 'youHaveAFewActiveSessions',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get unknownError {
    return Intl.message(
      'Unknown error',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `When you help your first client, you will see your session history here.`
  String get whenYouHelpYourFirstClientYouWillSeeYourSessionHistoryHere {
    return Intl.message(
      'When you help your first client, you will see your session history here.',
      name: 'whenYouHelpYourFirstClientYouWillSeeYourSessionHistoryHere',
      desc: '',
      args: [],
    );
  }

  /// `Your client session history will appear here`
  String get yourClientSessionHistoryWillAppearHere {
    return Intl.message(
      'Your client session history will appear here',
      name: 'yourClientSessionHistoryWillAppearHere',
      desc: '',
      args: [],
    );
  }

  /// `Status Text may not exceed 300 characters`
  String get statusTextMayNotExceed300Characters {
    return Intl.message(
      'Status Text may not exceed 300 characters',
      name: 'statusTextMayNotExceed300Characters',
      desc: '',
      args: [],
    );
  }

  /// `Uh-oh. It looks like you've lost your connection. Please try again.`
  String get uhOhItLooksLikeYouVeLostYourConnectionPleaseTryAgain {
    return Intl.message(
      'Uh-oh. It looks like you\'ve lost your connection. Please try again.',
      name: 'uhOhItLooksLikeYouVeLostYourConnectionPleaseTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Required field`
  String get requiredField {
    return Intl.message(
      'Required field',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Customers want to know you're a real person. The more photos you add, the more trust you can build.`
  String
      get customersWantToKnowYouReARealPersonTheMorePhotosYouAddTheMoreTrustYouCanBuild {
    return Intl.message(
      'Customers want to know you\'re a real person. The more photos you add, the more trust you can build.',
      name:
          'customersWantToKnowYouReARealPersonTheMorePhotosYouAddTheMoreTrustYouCanBuild',
      desc: '',
      args: [],
    );
  }

  /// `Complete your profile to start work`
  String get completeYourProfileToStartWork {
    return Intl.message(
      'Complete your profile to start work',
      name: 'completeYourProfileToStartWork',
      desc: '',
      args: [],
    );
  }

  /// `You're not live on the platform`
  String get youReNotLiveOnThePlatform {
    return Intl.message(
      'You\'re not live on the platform',
      name: 'youReNotLiveOnThePlatform',
      desc: '',
      args: [],
    );
  }

  /// `Please ensure your profile is completed for all languages. Need help? Contact your manager.`
  String
      get pleaseEnsureYourProfileIsCompletedForAllLanguagesNeedHelpContactYourManager {
    return Intl.message(
      'Please ensure your profile is completed for all languages. Need help? Contact your manager.',
      name:
          'pleaseEnsureYourProfileIsCompletedForAllLanguagesNeedHelpContactYourManager',
      desc: '',
      args: [],
    );
  }

  /// `You need to accept the advisor contract`
  String get youNeedToAcceptTheAdvisorContract {
    return Intl.message(
      'You need to accept the advisor contract',
      name: 'youNeedToAcceptTheAdvisorContract',
      desc: '',
      args: [],
    );
  }

  /// `Please login to the web version of your account.`
  String get pleaseLoginToTheWebVersionOfYourAccount {
    return Intl.message(
      'Please login to the web version of your account.',
      name: 'pleaseLoginToTheWebVersionOfYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `You're currently offline`
  String get youReCurrentlyOffline {
    return Intl.message(
      'You\'re currently offline',
      name: 'youReCurrentlyOffline',
      desc: '',
      args: [],
    );
  }

  /// `Change your status in your profile to make yourself visible to users.`
  String get changeYourStatusInYourProfileToMakeYourselfVisibleToUsers {
    return Intl.message(
      'Change your status in your profile to make yourself visible to users.',
      name: 'changeYourStatusInYourProfileToMakeYourselfVisibleToUsers',
      desc: '',
      args: [],
    );
  }

  /// `Tell our team when you plan to return:`
  String get tellOurTeamWhenYouPlanToReturn {
    return Intl.message(
      'Tell our team when you plan to return:',
      name: 'tellOurTeamWhenYouPlanToReturn',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete this audio message?`
  String get doYouWantToDeleteThisAudioMessage {
    return Intl.message(
      'Do you want to delete this audio message?',
      name: 'doYouWantToDeleteThisAudioMessage',
      desc: '',
      args: [],
    );
  }

  /// `You don't have an internet connection`
  String get youDontHaveAnInternetConnection {
    return Intl.message(
      'You don\'t have an internet connection',
      name: 'youDontHaveAnInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Add any information you want to remember about this client.`
  String get addAnyInformationYouWantToRememberAboutThisClient {
    return Intl.message(
      'Add any information you want to remember about this client.',
      name: 'addAnyInformationYouWantToRememberAboutThisClient',
      desc: '',
      args: [],
    );
  }

  /// `You've reach the {maxRecordDurationInMinutes} minute time limit.`
  String youVeReachTheXMinuteTimeLimit(Object maxRecordDurationInMinutes) {
    return Intl.message(
      'You\'ve reach the $maxRecordDurationInMinutes minute time limit.',
      name: 'youVeReachTheXMinuteTimeLimit',
      desc: '',
      args: [maxRecordDurationInMinutes],
    );
  }

  /// `Preferred topics`
  String get preferredTopics {
    return Intl.message(
      'Preferred topics',
      name: 'preferredTopics',
      desc: '',
      args: [],
    );
  }

  /// `Permission Needed`
  String get permissionNeeded {
    return Intl.message(
      'Permission Needed',
      name: 'permissionNeeded',
      desc: '',
      args: [],
    );
  }

  /// `We need permission to access your camera and gallery so you can send images`
  String get weNeedPermissionToAccessYourCameraAndGallerySoYouCanSendImages {
    return Intl.message(
      'We need permission to access your camera and gallery so you can send images',
      name: 'weNeedPermissionToAccessYourCameraAndGallerySoYouCanSendImages',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to reject this question?`
  String get doYouWantToRejectThisQuestion {
    return Intl.message(
      'Do you want to reject this question?',
      name: 'doYouWantToRejectThisQuestion',
      desc: '',
      args: [],
    );
  }

  /// `It will go back into the general queue.`
  String get itWillGoBackIntoTheGeneralQueue {
    return Intl.message(
      'It will go back into the general queue.',
      name: 'itWillGoBackIntoTheGeneralQueue',
      desc: '',
      args: [],
    );
  }

  /// `You must answer your active public question before you can help someone else.`
  String get youMustAnswerYourActivePublicQuestionBeforeYouCanHelpSomeoneElse {
    return Intl.message(
      'You must answer your active public question before you can help someone else.',
      name: 'youMustAnswerYourActivePublicQuestionBeforeYouCanHelpSomeoneElse',
      desc: '',
      args: [],
    );
  }

  /// `RETURN\nTO QUEUE`
  String get returnToQueue {
    return Intl.message(
      'RETURN\nTO QUEUE',
      name: 'returnToQueue',
      desc: '',
      args: [],
    );
  }

  /// `No sessions found with this filter`
  String get noSessionsFoundWithThisFilter {
    return Intl.message(
      'No sessions found with this filter',
      name: 'noSessionsFoundWithThisFilter',
      desc: '',
      args: [],
    );
  }

  /// `When someone asks a public question, you'll see them on this list`
  String get whenSomeoneAsksAPublicQuestionYouLlSeeThemOnThisList {
    return Intl.message(
      'When someone asks a public question, you\'ll see them on this list',
      name: 'whenSomeoneAsksAPublicQuestionYouLlSeeThemOnThisList',
      desc: '',
      args: [],
    );
  }

  /// `Choose photo from library`
  String get choosePhotoFromLibrary {
    return Intl.message(
      'Choose photo from library',
      name: 'choosePhotoFromLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Use your new password to login`
  String get useYourNewPasswordToLogin {
    return Intl.message(
      'Use your new password to login',
      name: 'useYourNewPasswordToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Open email`
  String get openEmail {
    return Intl.message(
      'Open email',
      name: 'openEmail',
      desc: '',
      args: [],
    );
  }

  /// `We've sent password reset instructions to {email}.`
  String weVeSentPasswordResetInstructionsToEmail(Object email) {
    return Intl.message(
      'We\'ve sent password reset instructions to $email.',
      name: 'weVeSentPasswordResetInstructionsToEmail',
      desc: '',
      args: [email],
    );
  }

  /// `Enter your email address and we'll send you instructions to create a new password`
  String
      get enterYourEmailAddressAndWeLlSendYouInstructionsToCreateANewPassword {
    return Intl.message(
      'Enter your email address and we\'ll send you instructions to create a new password',
      name:
          'enterYourEmailAddressAndWeLlSendYouInstructionsToCreateANewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Wrong username and/or password.`
  String get wrongUsernameAndOrPassword {
    return Intl.message(
      'Wrong username and/or password.',
      name: 'wrongUsernameAndOrPassword',
      desc: '',
      args: [],
    );
  }

  /// `We need permission to access your microphone`
  String get weNeedPermissionToAccessYourMicrophone {
    return Intl.message(
      'We need permission to access your microphone',
      name: 'weNeedPermissionToAccessYourMicrophone',
      desc: '',
      args: [],
    );
  }

  /// `Type message`
  String get typeMessage {
    return Intl.message(
      'Type message',
      name: 'typeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm that your answer is ready to be sent`
  String get pleaseConfirmThatYourAnswerIsReadyToBeSent {
    return Intl.message(
      'Please confirm that your answer is ready to be sent',
      name: 'pleaseConfirmThatYourAnswerIsReadyToBeSent',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterYourPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password`
  String get enterNewPassword {
    return Intl.message(
      'Enter new password',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Repeat new password`
  String get repeatNewPassword {
    return Intl.message(
      'Repeat new password',
      name: 'repeatNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterYourEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `My Gallery`
  String get myGallery {
    return Intl.message(
      'My Gallery',
      name: 'myGallery',
      desc: '',
      args: [],
    );
  }

  /// `Please update the app`
  String get pleaseUpdateTheApp {
    return Intl.message(
      'Please update the app',
      name: 'pleaseUpdateTheApp',
      desc: '',
      args: [],
    );
  }

  /// `This version of the app is no longer supported. To get back to all your conversations, install the latest version`
  String get thisVersionOfTheAppIsNoLongerSupported {
    return Intl.message(
      'This version of the app is no longer supported. To get back to all your conversations, install the latest version',
      name: 'thisVersionOfTheAppIsNoLongerSupported',
      desc: '',
      args: [],
    );
  }

  /// `Learn More`
  String get learnMore {
    return Intl.message(
      'Learn More',
      name: 'learnMore',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Message is not sent`
  String get messageIsNotSent {
    return Intl.message(
      'Message is not sent',
      name: 'messageIsNotSent',
      desc: '',
      args: [],
    );
  }

  /// `Recording is not possible, allocate space on the device`
  String get recordingIsNotPossibleAllocateSpaceOnTheDevice {
    return Intl.message(
      'Recording is not possible, allocate space on the device',
      name: 'recordingIsNotPossibleAllocateSpaceOnTheDevice',
      desc: '',
      args: [],
    );
  }

  /// `Notifications are disabled`
  String get notificationsAreDisabled {
    return Intl.message(
      'Notifications are disabled',
      name: 'notificationsAreDisabled',
      desc: '',
      args: [],
    );
  }

  /// `To enable notification, you’ll need to allow notifications in your phone settings`
  String get toEnableNotificationYoullNeedToAllowNotificationsInYour {
    return Intl.message(
      'To enable notification, you’ll need to allow notifications in your phone settings',
      name: 'toEnableNotificationYoullNeedToAllowNotificationsInYour',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Tap to copy`
  String get tapToCopy {
    return Intl.message(
      'Tap to copy',
      name: 'tapToCopy',
      desc: '',
      args: [],
    );
  }

  /// `Copied!`
  String get copied {
    return Intl.message(
      'Copied!',
      name: 'copied',
      desc: '',
      args: [],
    );
  }

  /// `Not specified`
  String get notSpecified {
    return Intl.message(
      'Not specified',
      name: 'notSpecified',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get newPassword {
    return Intl.message(
      'New password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
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
  Future<S> load(Locale locale) => S.load(locale);
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
