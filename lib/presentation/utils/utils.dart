import 'package:flutter/material.dart';

class Utils {
  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static int getTextNumLines(String text, double maxWidth, TextStyle? style) {
    final ts = TextSpan(text: text, style: style);
    final tp = TextPainter(text: ts, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: maxWidth);
    return tp.computeLineMetrics().length;
  }

  static double getTextHeight(String text, double maxWidth, TextStyle? style) {
    TextPainter textPainter = TextPainter()
      ..text = TextSpan(text: text, style: style)
      ..textDirection = TextDirection.ltr
      ..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size.height;
  }

  static void animateToWidget(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(context,
            duration: const Duration(milliseconds: 500));
      }
    });
  }
}
