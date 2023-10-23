import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/cache/caching_manager.dart';
import 'generated/intl/messages_all.dart';
import 'generated/l10n.dart';
import 'global.dart';
import 'infrastructure/di/app_initializer.dart';
import 'infrastructure/flavor/flavor_config.dart';
import 'infrastructure/routing/app_router.gr.dart';
import 'main_cubit.dart';
import 'multiple_localization/multiple_localization.dart';
import 'presentation/common_widgets/app_loading_indicator.dart';
import 'themes/app_themes.dart';

BuildContext? currentContext;

void main() async {
  runZonedGuarded(
    () async {
      await AppInitializer.setupPrerequisites(
        Flavor.production,
      );

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      runApp(const MyApp());
    },
    (error, stack) {
      logger.d("App Error with: $error");

      logger.d("App Error stack: $stack");
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final CachingManager _cacheManager = globalGetIt.get<CachingManager>();

  final MainAppRouter rootRouter = MainAppRouter();

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
    globalGetIt.get<MainCubit>().clearErrorMessage();
  }

  void _setContext() {
    if (navigator?.context != null) {
      currentContext = navigator?.context;
    }
  }
}

class _S extends SFortunica {
  static const _SDelegate delegate = _SDelegate();
}

class _SDelegate extends LocalizationsDelegate<SFortunica> {
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
  Future<SFortunica> load(Locale locale) {
    return MultipleLocalizations.load(
        initializeMessages, locale, (l) => SFortunica.load(Locale(l)),
        setDefaultLocale: true);
  }

  @override
  bool shouldReload(LocalizationsDelegate<SFortunica> old) {
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
