import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/di/bindings/init_binding.dart';
import 'package:shared_advisor_interface/presentation/resources/routes.dart';
import 'package:shared_advisor_interface/presentation/screens/Login/login_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_binding.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_binding.dart';
import 'package:shared_advisor_interface/presentation/screens/notifications/notifications_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/splash/splash_screen.dart';
import 'package:shared_advisor_interface/presentation/themes/app_themes.dart';

final logger = Logger(printer: SimplePrinter());

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<GetPage> getPages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationsScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.themeLight(context),
      darkTheme: AppThemes.themeDark(context),
      initialRoute: Routes.splash,
      initialBinding: InitBinding(),
      getPages: getPages,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
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
      },
    );
  }
}
