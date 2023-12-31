import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_loading_indicator.dart';
import 'package:shared_advisor_interface/presentation/di/injector.dart';
import 'package:shared_advisor_interface/presentation/di/modules/api_module.dart';
import 'package:shared_advisor_interface/presentation/di/modules/repository_module.dart';
import 'package:shared_advisor_interface/presentation/di/modules/services_module.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/themes/app_themes.dart';

final GetIt getIt = GetIt.instance;

final Logger simpleLogger = Logger(printer: SimplePrinter());

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    printTime: false,
  ),
);

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: AppConstants.iosApiKey,
            appId: AppConstants.iosAppId,
            messagingSenderId: AppConstants.firebaseMessagingSenderId,
            projectId: AppConstants.firebaseProjectId));
  } else {
    await Firebase.initializeApp();
  }

  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };
  await GetStorage.init();
  await Injector.instance.inject([
    ServicesModule(),
    ApiModule(),
    RepositoryModule(),
  ]);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final CachingManager _cacheManager = getIt.get<CachingManager>();

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      getIt.get<MainCubit>().widgetOnPauseEvent();
    }
    if (state == AppLifecycleState.resumed) {
      getIt.get<MainCubit>().widgetOnResumeEvent();
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
      create: (_) => getIt.get<MainCubit>(),
      child: Builder(builder: (context) {
        final Locale? locale =
            context.select((MainCubit cubit) => cubit.state.locale);
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              GetMaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppThemes.themeLight(context),
                darkTheme: AppThemes.themeDark(context),
                defaultTransition: Transition.cupertino,
                initialRoute: AppRoutes.splash,
                getPages: AppRoutes.getPages,
                navigatorKey: navigatorKey,
                locale: locale,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                localeResolutionCallback: (locale, supportedLocales) {
                  final String? languageCode = _cacheManager.getLanguageCode();

                  Locale? newLocale =
                      supportedLocales.toList().firstWhereOrNull(
                            (element) =>
                                element.languageCode ==
                                (languageCode ?? locale?.languageCode),
                          );
                  newLocale ??= supportedLocales.first;

                  getIt.get<Dio>().addLocaleToHeader(newLocale.languageCode);
                  return newLocale;
                },
                navigatorObservers: <NavigatorObserver>[
                  observer,
                  _AppNavigatorObserver(),
                ],
              ),
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

class _AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    _clearErrorMessage();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _clearErrorMessage();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _clearErrorMessage();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _clearErrorMessage();
  }

  void _clearErrorMessage() {
    getIt.get<MainCubit>().clearErrorMessage();
  }
}
