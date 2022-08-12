import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_light.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_dark.dart';

class AppThemes {

  static ThemeData themeLight(BuildContext context) {
    final Map<int, Color> color = {
      50: const Color.fromRGBO(77, 176, 91, .1),
      100: const Color.fromRGBO(77, 176, 91, .2),
      200: const Color.fromRGBO(77, 176, 91, .3),
      300: const Color.fromRGBO(77, 176, 91, .4),
      400: const Color.fromRGBO(77, 176, 91, .5),
      500: const Color.fromRGBO(77, 176, 91, .6),
      600: const Color.fromRGBO(77, 176, 91, .7),
      700: const Color.fromRGBO(77, 176, 91, .8),
      800: const Color.fromRGBO(77, 176, 91, .9),
      900: const Color.fromRGBO(77, 176, 91, 1),
    };
    return ThemeData(
      scaffoldBackgroundColor: AppColorsLight.background,
      primarySwatch: MaterialColor(0xFF4DB05B, color),
      canvasColor: Colors.white,
      primaryColor: AppColorsLight.primary,
      disabledColor: Colors.grey,
      hoverColor: AppColorsLight.ui,
      brightness: Brightness.light,
      primaryColorDark: Colors.black,
      indicatorColor: Colors.black,
      splashColor: Colors.red.shade50,
      hintColor: Colors.grey.shade400,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontWeight: FontWeight.bold))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              textStyle: const TextStyle(fontWeight: FontWeight.w500))),
    );
  }

  static ThemeData themeDark(BuildContext context) {
    final Map<int, Color> color = {
      50: const Color.fromRGBO(106, 204, 101, .1),
      100: const Color.fromRGBO(106, 204, 101, .2),
      200: const Color.fromRGBO(106, 204, 101, .3),
      300: const Color.fromRGBO(106, 204, 101, .4),
      400: const Color.fromRGBO(106, 204, 101, .5),
      500: const Color.fromRGBO(106, 204, 101, .6),
      600: const Color.fromRGBO(106, 204, 101, .7),
      700: const Color.fromRGBO(106, 204, 101, .8),
      800: const Color.fromRGBO(106, 204, 101, .9),
      900: const Color.fromRGBO(106, 204, 101, 1),
    };
    return ThemeData(
      scaffoldBackgroundColor: AppColorsDark.background,
      primarySwatch: MaterialColor(0xFF6ACC65, color),
      primaryColor: AppColorsDark.primary,
      primaryColorLight: Colors.black,
      brightness: Brightness.dark,
      primaryColorDark: Colors.black,
      indicatorColor: Colors.white,
      canvasColor: Colors.black,
      disabledColor: Colors.grey,
      hoverColor: AppColorsDark.ui,
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              primary: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.bold))),
    );
  }
}