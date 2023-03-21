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
