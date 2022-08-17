import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_light.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_dark.dart';

class AppThemes {
  static ThemeData themeLight(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: AppColorsLight.background,
      canvasColor: Colors.white,
      primaryColor: AppColorsLight.primary,
      disabledColor: Colors.grey,
      hoverColor: AppColorsLight.ui,
      brightness: Brightness.light,
      primaryColorDark: Colors.black,
      indicatorColor: Colors.black,
      splashColor: Colors.red.shade50,
      hintColor: Colors.grey.shade400,
      errorColor: AppColorsLight.error,
      focusColor: AppColorsLight.cta,
      iconTheme: const IconThemeData(
          color: AppColorsLight.inactive1,
      ),
      colorScheme: ThemeData().colorScheme.copyWith(
        primary: AppColorsLight.inactive1,
      ),
      textTheme: const TextTheme(
        labelMedium: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: AppColorsLight.secondary,
        ),
        labelSmall: TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.w500,
          color: AppColorsLight.secondary,
        ),
        titleMedium: TextStyle(
            color: AppColorsLight.secondary,
            fontSize: 17.0,
            fontWeight: FontWeight.w600),
        bodySmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 13.0,
          color: AppColorsLight.secondary,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15.0,
          color: AppColorsLight.secondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        primary: AppColorsLight.cta,
        textStyle: const TextStyle(
            color: AppColorsLight.uinegative,
            fontSize: 17.0,
            fontWeight: FontWeight.w600),
      )),
      // textButtonTheme: TextButtonThemeData(
      //     style: TextButton.styleFrom(
      //         textStyle: const TextStyle(
      //             color: AppColorsLight.uinegative,
      //             fontSize: 17.0,
      //             fontWeight: FontWeight.w600),),),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColorsLight.highLight),
            borderRadius: BorderRadius.circular(8.0)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColorsLight.error),
            borderRadius: BorderRadius.circular(8.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColorsLight.highLight),
            borderRadius: BorderRadius.circular(8.0)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColorsLight.highLight),
            borderRadius: BorderRadius.circular(8.0)),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColorsLight.highLight),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  static ThemeData themeDark(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: AppColorsDark.background,
      primaryColor: AppColorsDark.primary,
      primaryColorLight: Colors.black,
      brightness: Brightness.dark,
      primaryColorDark: Colors.black,
      indicatorColor: Colors.white,
      canvasColor: Colors.black,
      disabledColor: Colors.grey,
      hoverColor: AppColorsDark.ui,
      errorColor: AppColorsDark.error,
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              primary: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.bold))),
    );
  }
}
