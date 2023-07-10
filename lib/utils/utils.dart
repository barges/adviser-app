import 'package:collection/collection.dart';
import 'package:shared_advisor_interface/themes/app_colors_dark.dart';
import 'package:shared_advisor_interface/themes/app_colors_light.dart';
import 'package:flutter/material.dart';

Function unorderedDeepListEquals =
    const DeepCollectionEquality.unordered().equals;

class Utils {
  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static int getTextNumLines(String text, double maxWidth, TextStyle? style) {
    final ts = TextSpan(text: text, style: style);
    final tp = TextPainter(text: ts, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: maxWidth);
    return tp.computeLineMetrics().length;
  }

  static double getTextHeight(String text, TextStyle? style, double maxWidth,
      {int? maxLines}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
      textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
    )..layout(maxWidth: maxWidth);
    return textPainter.size.height;
  }

  static void animateToWidget(GlobalKey key, {double alignment = 0.0}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          alignment: alignment,
          duration: const Duration(milliseconds: 500),
        );
      }
    });
  }

  static Color getOverlayColor(BuildContext context) {
    return isDarkMode(context) ? AppColorsDark.overlay : AppColorsLight.overlay;
  }

  /// Checks if string is URL.
  static bool isURL(String s) => hasMatch(s,
      r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$");

  /// Checks if string is email.
  static bool isEmail(String s) => hasMatch(s,
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  /// Checks if string is phone number.
  static bool isPhoneNumber(String s) {
    if (s.length > 16 || s.length < 9) return false;
    return hasMatch(s, r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  }

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }
}
