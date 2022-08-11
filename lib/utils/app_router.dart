import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/screens/Login/forget_password_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/Login/login_screen.dart';
import 'package:shared_advisor_interface/utils/routes.dart';

class AppRouter {
  static final AppRouter _appRoutes = AppRouter._internal();

  factory AppRouter() => _appRoutes;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.logIn:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPasswordScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  AppRouter._internal();
}
