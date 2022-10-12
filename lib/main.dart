import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/cache/data_cache_manager.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/main_state.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_loading_indicator.dart';
import 'package:shared_advisor_interface/presentation/di/bindings/init_binding.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/themes/app_themes.dart';

final Logger simpleLogger = Logger(printer: SimplePrinter());

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    printTime: false,
  ),
);

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CacheManager _cacheManager =
      Get.put<CacheManager>(DataCacheManager(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Get.put<MainCubit>(MainCubit(_cacheManager)),
      child: Builder(builder: (context) {
        return BlocListener<MainCubit, MainState>(
          listenWhen: (prev, current) => prev.isLoading != current.isLoading,
          listener: (_, state) {
            if (state.isLoading) {
              _showNoConnectionDialog();
            } else {
              Get.back();
            }
          },
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppThemes.themeLight(context),
            darkTheme: AppThemes.themeDark(context),
            defaultTransition: Transition.cupertino,
            initialRoute: AppRoutes.splash,
            initialBinding: InitBinding(),
            getPages: AppRoutes.getPages,
            navigatorKey: navigatorKey,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            localeResolutionCallback: (locale, supportedLocales) {
              final int? localeIndex = _cacheManager.getLocaleIndex();

              if (localeIndex != null) {
                return supportedLocales.toList()[localeIndex];
              } else {
                if (locale == null) {
                  return supportedLocales.first;
                }
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode ||
                      supportedLocale.countryCode == locale.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              }
            },
          ),
        );
      }),
    );
  }

  void _showNoConnectionDialog() {
    showGeneralDialog(
      context: navigatorKey.currentContext!,
      barrierColor: Get.theme.scaffoldBackgroundColor
          .withOpacity(Get.isDarkMode ? 0.6 : 0.2),
      // Background color
      barrierDismissible: false,
      barrierLabel: 'LOADING',
      transitionDuration: const Duration(milliseconds: 100),
      // How long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) {
        // Makes widget fullscreen
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: const AppLoadingIndicator(),
        );
      },
    );
  }
}
