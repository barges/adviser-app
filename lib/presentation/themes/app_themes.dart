import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_light.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_dark.dart';

class AppThemes {
  static final AppThemes _appColorsDark = AppThemes._internal();

  factory AppThemes() => _appColorsDark;

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
      textTheme: _textLightTheme(),
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
      textTheme: _textDarkTheme(),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              primary: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.bold))),
    );
  }

  AppThemes._internal();
}

TextTheme _textLightTheme() {
  return TextTheme(
    headline1: GoogleFonts.redHatDisplay(
        color: AppColorsLight.darkBlue,
        fontSize: 17.0,
        fontWeight: FontWeight.w400),
    labelMedium: GoogleFonts.redHatDisplay(color: AppColorsLight.secondary),
    titleMedium: GoogleFonts.redHatDisplay(
        fontWeight: FontWeight.w500, color: AppColorsLight.darkBlue),
    bodyMedium: GoogleFonts.redHatDisplay(
        fontWeight: FontWeight.w400,
        fontSize: 15.0,
        color: AppColorsLight.darkBlue),
    bodySmall: GoogleFonts.redHatDisplay(
        color: AppColorsLight.error,
        fontSize: 13.0,
        fontWeight: FontWeight.w400),
  );
}

TextTheme _textDarkTheme() {
  return TextTheme(
    headline1: GoogleFonts.redHatDisplay(
        color: AppColorsDark.darkBlue,
        fontSize: 17.0,
        fontWeight: FontWeight.w400),
    labelMedium: GoogleFonts.redHatDisplay(color: AppColorsDark.secondary),
    titleMedium: GoogleFonts.redHatDisplay(
        fontWeight: FontWeight.w500, color: AppColorsDark.darkBlue),
    bodyMedium: GoogleFonts.redHatDisplay(
        fontWeight: FontWeight.w400,
        fontSize: 15.0,
        color: AppColorsDark.darkBlue),
    bodySmall: GoogleFonts.redHatDisplay(
        color: AppColorsDark.error,
        fontSize: 13.0,
        fontWeight: FontWeight.w400),
  );
}
