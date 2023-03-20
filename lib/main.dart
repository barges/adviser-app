import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:multiple_localization/multiple_localization.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/generated/intl/messages_all.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_loading_indicator.dart';
import 'package:shared_advisor_interface/themes/app_themes.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

import 'infrastructure/di/app_initializer.dart';
import 'infrastructure/di/brand_manager.dart';

void main() async {
  await AppInitializer.setupPrerequisites(
    Flavor.production,
  );

  runZonedGuarded(
    () async {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      runApp(const MyApp());
    },
    (error, stack) {
      log("App Error with: $error");

      log("App Error stack: $stack");
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalCachingManager _cacheManager =
      globalGetIt.get<GlobalCachingManager>();

  final MainAppRouter rootRouter = MainAppRouter();

  final BrandManager brandManager = globalGetIt.get<BrandManager>();

  final AppRouter routerService = globalGetIt.get<AppRouter>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      globalGetIt.get<MainCubit>().widgetOnPauseEvent();
    }
    if (state == AppLifecycleState.resumed) {
      globalGetIt.get<MainCubit>().widgetOnResumeEvent();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => globalGetIt.get<MainCubit>(),
      child: Builder(builder: (context) {
        final Locale? locale =
            context.select((MainCubit cubit) => cubit.state.locale);
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              MaterialApp.router(
                  theme: AppThemes.themeLight(context),
                  darkTheme: AppThemes.themeDark(context),
                  routerDelegate: rootRouter.delegate(
                    navigatorObservers: () => [_AppNavigatorObserver()],
                  ),
                  routeInformationProvider: rootRouter.routeInfoProvider(),
                  routeInformationParser: rootRouter.defaultRouteParser(),
                  locale: locale,
                  localizationsDelegates: const [
                    _S.delegate,
                    SFortunica.delegate,
                    SZodiac.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: _S.delegate.supportedLocales,
                  localeResolutionCallback: (locale, supportedLocales) {
                    final String? languageCode =
                        _cacheManager.getLanguageCode();

                    Locale? newLocale =
                        supportedLocales.toList().firstWhereOrNull(
                              (element) =>
                                  element.languageCode ==
                                  (languageCode ?? locale?.languageCode),
                            );
                    newLocale ??= supportedLocales.first;

                    if (languageCode == null) {
                      final String code = newLocale.languageCode;
                      _cacheManager.saveLanguageCode(code);
                      Configuration.setBrandsLocales(code);
                    }

                    return newLocale;
                  },
                  title: 'Advisor App',
                  builder: (context, router) {
                    return Scaffold(
                      body: router!,
                      key: scaffoldKey,
                    );
                  }),
              Builder(builder: (context) {
                final bool isLoading =
                    context.select((MainCubit cubit) => cubit.state.isLoading);
                return isLoading
                    ? const AppLoadingIndicator()
                    : const SizedBox.shrink();
              }),
            ],
          ),
        );
      }),
    );
  }
}

class _AppNavigatorObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _clearErrorMessage();
    _setContext();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _clearErrorMessage();
    _setContext();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _clearErrorMessage();
    _setContext();
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    super.didInitTabRoute(route, previousRoute);
    _setContext();
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    super.didChangeTabRoute(route, previousRoute);
    _setContext();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _clearErrorMessage();
    _setContext();
  }

  void _clearErrorMessage() {
    fortunicaGetIt.get<FortunicaMainCubit>().clearErrorMessage();
    zodiacGetIt.get<ZodiacMainCubit>().clearErrorMessage();
  }

  void _setContext() {
    final BuildContext? currentContext = navigator?.context;
    if (currentContext != null) {
      final String path = currentContext.router.current.path;
      logger.d('context $path');
      if (path.contains(Brand.fortunicaAlias)) {
        Configuration.fortunicaContext = currentContext;
      } else if (path.contains(Brand.zodiacAlias)) {
        Configuration.zodiacContext = currentContext;
      }
    }
  }
}

class _S extends S {
  static const _SDelegate delegate = _SDelegate();
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

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
  Future<S> load(Locale locale) {
    return MultipleLocalizations.load(
        initializeMessages, locale, (l) => S.load(Locale(l)),
        setDefaultLocale: true);
  }

  @override
  bool shouldReload(LocalizationsDelegate<S> old) {
    return false;
  }

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
