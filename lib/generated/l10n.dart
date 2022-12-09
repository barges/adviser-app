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

  /// `Customers want to see if you are real. The more photos of yourself you add, the better.`
  String get customersWantSeeIfYouReal {
    return Intl.message(
      'Customers want to see if you are real. The more photos of yourself you add, the better.',
      name: 'customersWantSeeIfYouReal',
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

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Portuguese`
  String get portuguese {
    return Intl.message(
      'Portuguese',
      name: 'portuguese',
      desc: '',
      args: [],
    );
  }

  /// `Wrong username or password`
  String get wrongUsernameOrPassword {
    return Intl.message(
      'Wrong username or password',
      name: 'wrongUsernameOrPassword',
      desc: '',
      args: [],
    );
  }

  /// `Open email app`
  String get openEmailApp {
    return Intl.message(
      'Open email app',
      name: 'openEmailApp',
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

  /// `All our brands`
  String get allOurBrands {
    return Intl.message(
      'All our brands',
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

  /// `Fortunica`
  String get fortunica {
    return Intl.message(
      'Fortunica',
      name: 'fortunica',
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

  /// `You have`
  String get youHave {
    return Intl.message(
      'You have',
      name: 'youHave',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get days {
    return Intl.message(
      'days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `to read it before your account will get blocked!`
  String get toReadItBeforeYourAccountWillGetBlocked {
    return Intl.message(
      'to read it before your account will get blocked!',
      name: 'toReadItBeforeYourAccountWillGetBlocked',
      desc: '',
      args: [],
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

  /// `Choose from gallery`
  String get chooseFromGallery {
    return Intl.message(
      'Choose from gallery',
      name: 'chooseFromGallery',
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

  /// `Better than`
  String get betterThan {
    return Intl.message(
      'Better than',
      name: 'betterThan',
      desc: '',
      args: [],
    );
  }

  /// `advisors`
  String get advisors {
    return Intl.message(
      'advisors',
      name: 'advisors',
      desc: '',
      args: [],
    );
  }

  /// `places up from last month`
  String get placesUpFromLastMonth {
    return Intl.message(
      'places up from last month',
      name: 'placesUpFromLastMonth',
      desc: '',
      args: [],
    );
  }

  /// `Personal Balance`
  String get personalBalance {
    return Intl.message(
      'Personal Balance',
      name: 'personalBalance',
      desc: '',
      args: [],
    );
  }

  /// `New customers`
  String get newCustomers {
    return Intl.message(
      'New customers',
      name: 'newCustomers',
      desc: '',
      args: [],
    );
  }

  /// `Sales`
  String get sales {
    return Intl.message(
      'Sales',
      name: 'sales',
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

  /// `Inform our team your planned return date:`
  String get informOurTeamYourPlannedReturnDate {
    return Intl.message(
      'Inform our team your planned return date:',
      name: 'informOurTeamYourPlannedReturnDate',
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

  /// `Field is required`
  String get fieldIsRequired {
    return Intl.message(
      'Field is required',
      name: 'fieldIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
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

  /// `People helped`
  String get peopleHelped {
    return Intl.message(
      'People helped',
      name: 'peopleHelped',
      desc: '',
      args: [],
    );
  }

  /// `Customer Profile`
  String get customerProfile {
    return Intl.message(
      'Customer Profile',
      name: 'customerProfile',
      desc: '',
      args: [],
    );
  }

  /// `Top spender`
  String get topSpender {
    return Intl.message(
      'Top spender',
      name: 'topSpender',
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

  /// `Zodiac Sign`
  String get zodiacSign {
    return Intl.message(
      'Zodiac Sign',
      name: 'zodiacSign',
      desc: '',
      args: [],
    );
  }

  /// `Numerology`
  String get numerology {
    return Intl.message(
      'Numerology',
      name: 'numerology',
      desc: '',
      args: [],
    );
  }

  /// `Ascendant`
  String get ascendant {
    return Intl.message(
      'Ascendant',
      name: 'ascendant',
      desc: '',
      args: [],
    );
  }

  /// `birth town`
  String get birthTown {
    return Intl.message(
      'birth town',
      name: 'birthTown',
      desc: '',
      args: [],
    );
  }

  /// `Question properties`
  String get questionProperties {
    return Intl.message(
      'Question properties',
      name: 'questionProperties',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
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

  /// `Add the information that you want to keep in mind about this client`
  String get addInformationYouWantKeepInMindAboutThisClient {
    return Intl.message(
      'Add the information that you want to keep in mind about this client',
      name: 'addInformationYouWantKeepInMindAboutThisClient',
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

  /// `All Type`
  String get allType {
    return Intl.message(
      'All Type',
      name: 'allType',
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

  /// `When someone asks a public question, you will see them on the general list here`
  String get whenSomeoneAsksAPublicQuestionYouWillSeeThem {
    return Intl.message(
      'When someone asks a public question, you will see them on the general list here',
      name: 'whenSomeoneAsksAPublicQuestionYouWillSeeThem',
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

  /// `When you help your first client, you will see your session history here.`
  String get whenYouHelpYourFirstClientYouWillSeeYour {
    return Intl.message(
      'When you help your first client, you will see your session history here.',
      name: 'whenYouHelpYourFirstClientYouWillSeeYour',
      desc: '',
      args: [],
    );
  }

  /// `Uh-oh, no network... \nCheck your internet connection`
  String get uhohNoNetworkNcheckYourInternetConnection {
    return Intl.message(
      'Uh-oh, no network... \nCheck your internet connection',
      name: 'uhohNoNetworkNcheckYourInternetConnection',
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

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
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

  /// `from 15 sec to 3 min`
  String get from15secTo3min {
    return Intl.message(
      'from 15 sec to 3 min',
      name: 'from15secTo3min',
      desc: '',
      args: [],
    );
  }

  /// `Type message`
  String get typemessage {
    return Intl.message(
      'Type message',
      name: 'typemessage',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete audio message?`
  String get doYouWantToDeleteAudioMessage {
    return Intl.message(
      'Do you want to delete audio message?',
      name: 'doYouWantToDeleteAudioMessage',
      desc: '',
      args: [],
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

  /// `Allow camera`
  String get allowCamera {
    return Intl.message(
      'Allow camera',
      name: 'allowCamera',
      desc: '',
      args: [],
    );
  }

  /// `Allow gallery`
  String get allowGallery {
    return Intl.message(
      'Allow gallery',
      name: 'allowGallery',
      desc: '',
      args: [],
    );
  }

  /// `To reset password, enter email address and we’ll send you instructions on how to create a new password.`
  String get toResetPasswordEnterEmailAddressAndWellSendYou {
    return Intl.message(
      'To reset password, enter email address and we’ll send you instructions on how to create a new password.',
      name: 'toResetPasswordEnterEmailAddressAndWellSendYou',
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

  /// `Return`
  String get return_ {
    return Intl.message(
      'Return',
      name: 'return_',
      desc: '',
      args: [],
    );
  }

  /// `RETURN\nIN QUEUE`
  String get returnInQueue {
    return Intl.message(
      'RETURN\nIN QUEUE',
      name: 'returnInQueue',
      desc: '',
      args: [],
    );
  }

  /// `You don’t have internet connection`
  String get youDontHaveInternetConnection {
    return Intl.message(
      'You don’t have internet connection',
      name: 'youDontHaveInternetConnection',
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

  /// `You’re currently not live on the platform, please make sure you fill out your profile for all languages. You can contact your Manager if you have questions.`
  String get youReCurrentlyNotLiveOnThePlatform {
    return Intl.message(
      'You’re currently not live on the platform, please make sure you fill out your profile for all languages. You can contact your Manager if you have questions.',
      name: 'youReCurrentlyNotLiveOnThePlatform',
      desc: '',
      args: [],
    );
  }

  /// `Before proceeding you need to accept contracts. To do so please open the web version of the Advisor Tool`
  String get beforeProceedingYouNeedToAcceptContracts {
    return Intl.message(
      'Before proceeding you need to accept contracts. To do so please open the web version of the Advisor Tool',
      name: 'beforeProceedingYouNeedToAcceptContracts',
      desc: '',
      args: [],
    );
  }

  /// `You’re currently Offline on the platform, you can’t use the full functionality and are not visible to users. You can change your status to Live in your profile.`
  String get youReCurrentlyOfflineOnThePlatform {
    return Intl.message(
      'You’re currently Offline on the platform, you can’t use the full functionality and are not visible to users. You can change your status to Live in your profile.',
      name: 'youReCurrentlyOfflineOnThePlatform',
      desc: '',
      args: [],
    );
  }

  /// `Complete profile to start helping`
  String get completeProfileToStartHelping {
    return Intl.message(
      'Complete profile to start helping',
      name: 'completeProfileToStartHelping',
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

  /// `You can not help users since you have an active public question.`
  String get youCanNotHelpUsersSinceYouHaveAnActive {
    return Intl.message(
      'You can not help users since you have an active public question.',
      name: 'youCanNotHelpUsersSinceYouHaveAnActive',
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

  /// `Add photo`
  String get addPhoto {
    return Intl.message(
      'Add photo',
      name: 'addPhoto',
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

  /// `Now you can login with a new password`
  String get nowYouCanLoginWithANewPassword {
    return Intl.message(
      'Now you can login with a new password',
      name: 'nowYouCanLoginWithANewPassword',
      desc: '',
      args: [],
    );
  }

  /// `We’ve sent you a link to {email} to change your password`
  String weVeSentYouALinkToEmailToChangeYourPassword(Object email) {
    return Intl.message(
      'We’ve sent you a link to $email to change your password',
      name: 'weVeSentYouALinkToEmailToChangeYourPassword',
      desc: '',
      args: [email],
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

  /// `You have an active session`
  String get youHaveAnActiveSession {
    return Intl.message(
      'You have an active session',
      name: 'youHaveAnActiveSession',
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

  /// `Just sent you a message`
  String get justSentYouAMessage {
    return Intl.message(
      'Just sent you a message',
      name: 'justSentYouAMessage',
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

  /// `This filtering option doesn’t contain any sessions`
  String get thisFilteringOptionDoesntContainAnySessions {
    return Intl.message(
      'This filtering option doesn’t contain any sessions',
      name: 'thisFilteringOptionDoesntContainAnySessions',
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

  /// `Aura Reading`
  String get auraReading {
    return Intl.message(
      'Aura Reading',
      name: 'auraReading',
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

  /// `You can’t send this message because it’s less than 15 seconds`
  String get youCantSendThisMessageBecauseItsLessThan15Seconds {
    return Intl.message(
      'You can’t send this message because it’s less than 15 seconds',
      name: 'youCantSendThisMessageBecauseItsLessThan15Seconds',
      desc: '',
      args: [],
    );
  }

  /// `Recording stopped because audio file is reached the limit of 3min`
  String get recordingStoppedBecauseAudioFileIsReachedTheLimitOf3min {
    return Intl.message(
      'Recording stopped because audio file is reached the limit of 3min',
      name: 'recordingStoppedBecauseAudioFileIsReachedTheLimitOf3min',
      desc: '',
      args: [],
    );
  }

  /// `The maximum image size is 20Mb.`
  String get theMaximumImageSizeIs20Mb {
    return Intl.message(
      'The maximum image size is 20Mb.',
      name: 'theMaximumImageSizeIs20Mb',
      desc: '',
      args: [],
    );
  }

  /// `You refuse to answer this question`
  String get youRefuseToAnswerThisQuestion {
    return Intl.message(
      'You refuse to answer this question',
      name: 'youRefuseToAnswerThisQuestion',
      desc: '',
      args: [],
    );
  }

  /// `It will go back into the general queue and you will not be able to take it again`
  String get itWillGoBackIntoTheGeneralQueueAndYouWillNotBeAbleToTakeItAgain {
    return Intl.message(
      'It will go back into the general queue and you will not be able to take it again',
      name: 'itWillGoBackIntoTheGeneralQueueAndYouWillNotBeAbleToTakeItAgain',
      desc: '',
      args: [],
    );
  }

  /// `This question will be returned to the general list after`
  String get thisQuestionWillBeReturnedToTheGeneralListAfterCounter {
    return Intl.message(
      'This question will be returned to the general list after',
      name: 'thisQuestionWillBeReturnedToTheGeneralListAfterCounter',
      desc: '',
      args: [],
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
