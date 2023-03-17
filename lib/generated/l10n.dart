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

  /// `Ingenio`
  String get ingenio {
    return Intl.message(
      'Ingenio',
      name: 'ingenio',
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

  /// `Workspaces`
  String get workspaces {
    return Intl.message(
      'Workspaces',
      name: 'workspaces',
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

  /// `We pride ourselves to offer advisors  a safe place to serve customers and develop professionally. Doing a good job in one of our brands will open doors to others`
  String get wePrideOurselvesToOfferAdvisorsASafePlaceTo {
    return Intl.message(
      'We pride ourselves to offer advisors  a safe place to serve customers and develop professionally. Doing a good job in one of our brands will open doors to others',
      name: 'wePrideOurselvesToOfferAdvisorsASafePlaceTo',
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

  /// `Other brands`
  String get otherBrands {
    return Intl.message(
      'Other brands',
      name: 'otherBrands',
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

  /// `Please update the app`
  String get pleaseUpdateTheApp {
    return Intl.message(
      'Please update the app',
      name: 'pleaseUpdateTheApp',
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

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
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
