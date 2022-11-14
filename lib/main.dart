import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_localizations/flutter_localizations.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await Injector.instance.inject([
    ServicesModule(),
    ApiModule(),
    RepositoryModule(),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CachingManager _cacheManager = getIt.get<CachingManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<MainCubit>(),
      child: Builder(builder: (context) {
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
              Builder(builder: (context) {
                final bool isLoading =
                    context.select((MainCubit cubit) => cubit.state.isLoading);
                return isLoading
                    ? const AppLoadingIndicator()
                    : const SizedBox.shrink();
              })
            ],
          ),
        );
      }),
    );
  }
}
