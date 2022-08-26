import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_light.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_dark.dart';

class AppThemes {
  static ThemeData themeLight(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: AppColorsLight.background,
      backgroundColor: AppColorsLight.uinegative,
      primaryColorLight: AppColorsLight.coloredBG,
      canvasColor: AppColorsLight.contrast,
      primaryColor: AppColorsLight.primary,
      brightness: Brightness.light,
      hintColor: AppColorsLight.shade1,
      errorColor: AppColorsLight.error,
      iconTheme: const IconThemeData(
        color: AppColorsLight.shade3,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
        color: AppColorsLight.contrast,
        // systemOverlayStyle: SystemUiOverlayStyle(
        //     statusBarColor: AppColorsLight.ui,
        //     statusBarBrightness: Brightness.light,
        //     statusBarIconBrightness: Brightness.dark),
      ),
      textTheme: GoogleFonts.redHatDisplayTextTheme(
        const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
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
            borderSide: const BorderSide(color: AppColorsLight.contrast),
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColorsLight.contrast),
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColorsLight.contrast),
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColorsLight.contrast),
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColorsLight.contrast),
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
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
