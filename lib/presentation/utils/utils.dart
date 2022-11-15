import 'package:flutter/material.dart';

class Utils {
  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}
