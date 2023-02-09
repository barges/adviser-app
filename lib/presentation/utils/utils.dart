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
