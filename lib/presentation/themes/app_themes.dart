import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_light.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_dark.dart';

class AppThemes {
  static ThemeData themeLight(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: AppColorsLight.background,
      backgroundColor: AppColorsLight.uinegative,
      canvasColor: AppColorsLight.contrast,
      primaryColor: AppColorsLight.primary,
      hoverColor: AppColorsLight.ui,
      brightness: Brightness.light,
      hintColor: AppColorsLight.shade3,
      errorColor: AppColorsLight.error,
      focusColor: AppColorsLight.accent,
      iconTheme: const IconThemeData(
        color: AppColorsLight.shade3,
      ),
      // colorScheme: ThemeData().colorScheme.copyWith(
      //       primary: AppColorsLight.inactive1,
      //     ),

      textTheme: GoogleFonts.redHatDisplayTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
            color: AppColorsLight.ui,
          ),
          labelMedium: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: AppColorsLight.ui,
          ),
          labelSmall: TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.w500,
            color: AppColorsLight.ui,
          ),
          titleMedium: TextStyle(
              color: AppColorsLight.ui,
              fontSize: 17.0,
              fontWeight: FontWeight.w600),
          bodySmall: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 13.0,
            color: AppColorsLight.ui,
          ),
          bodyMedium: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15.0,
            color: AppColorsLight.ui,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: AppColorsLight.accent,
          textStyle: const TextStyle(
              color: AppColorsLight.uinegative,
              fontSize: 17.0,
              fontWeight: FontWeight.w600),
        ),
      ),
      // textButtonTheme: TextButtonThemeData(
      //     style: TextButton.styleFrom(
      //         textStyle: const TextStyle(
      //             color: AppColorsLight.uinegative,
      //             fontSize: 17.0,
      //             fontWeight: FontWeight.w600),),),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColorsLight.shade1),
            borderRadius: BorderRadius.circular(8.0)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColorsLight.error),
            borderRadius: BorderRadius.circular(8.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColorsLight.shade1),
            borderRadius: BorderRadius.circular(8.0)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColorsLight.shade1),
            borderRadius: BorderRadius.circular(8.0)),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColorsLight.shade1),
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
