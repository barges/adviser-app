
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/screens/Login/forget_password_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/Login/login_screen.dart';

class AppRoutes {
  static final AppRoutes _appRoutes = AppRoutes._internal();

  factory AppRoutes() => _appRoutes;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'LoginScreen':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case 'ForgetPasswordScreen':
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
  AppRoutes._internal();
}