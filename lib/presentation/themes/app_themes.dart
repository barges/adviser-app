import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      hoverColor: AppColorsLight.ui,
      shadowColor: AppColorsLight.shade3,
      hintColor: AppColorsLight.shade1,
      errorColor: AppColorsLight.error,
      iconTheme: const IconThemeData(
        color: AppColorsLight.shade3,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.buttonRadius),
            topRight: Radius.circular(AppConstants.buttonRadius),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
        color: AppColorsLight.contrast,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark),
      ),
      textTheme: GoogleFonts.redHatDisplayTextTheme(
        const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w900,
              color: AppColorsLight.ui,
            ),
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
            displaySmall: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12.0,
              color: AppColorsLight.ui,
            ),
            bodyMedium: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15.0,
              color: AppColorsLight.ui,
            ),
            displayLarge: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: AppColorsLight.ui,
            )),
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
      backgroundColor: AppColorsDark.uinegative,
      primaryColorLight: AppColorsDark.coloredBG,
      canvasColor: AppColorsDark.contrast,
      primaryColor: AppColorsDark.primary,
      brightness: Brightness.light,
      hoverColor: AppColorsDark.ui,
      shadowColor: AppColorsDark.shade3,
      hintColor: AppColorsDark.shade1,
      errorColor: AppColorsDark.error,
      iconTheme: const IconThemeData(
        color: AppColorsDark.shade3,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
        color: AppColorsDark.contrast,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light),
      ),
      textTheme: GoogleFonts.redHatDisplayTextTheme(
        const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w900,
              color: AppColorsDark.ui,
            ),
            headlineMedium: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: AppColorsDark.ui,
            ),
            labelMedium: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: AppColorsDark.ui,
            ),
            labelSmall: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
              color: AppColorsDark.ui,
            ),
            titleMedium: TextStyle(
                color: AppColorsDark.ui,
                fontSize: 17.0,
                fontWeight: FontWeight.w600),
            bodySmall: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13.0,
              color: AppColorsDark.ui,
            ),
            displaySmall: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12.0,
              color: AppColorsDark.ui,
            ),
            bodyMedium: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15.0,
              color: AppColorsDark.ui,
            ),
            displayLarge: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: AppColorsDark.ui,
            )),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
              color: AppColorsDark.uinegative,
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
            borderSide: const BorderSide(color: AppColorsDark.contrast),
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColorsDark.contrast),
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColorsDark.contrast),
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColorsDark.contrast),
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColorsDark.contrast),
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        ),
      ),
    );
  }
}
