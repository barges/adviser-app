import 'package:flutter/painting.dart';

class AdvisorPreviewConstants {
  static const Color primary = Color(0xFF721C70);
  static const Color secondary = Color(0xFF26264E);

  static const Color color2 = Color(0xFF322C32);
  static const Color color3 = Color(0xFFAAA2AA);

  static const Color inactive1 = Color(0xFF878787);
  static const Color inactive2 = Color(0xFFBDBDBD);

  static const Color white = Color(0xFFFFFFFF);

  static const TextStyle appBarTitleStyle =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: color2);

  static const TextStyle displayLarge =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: primary);

  static const TextStyle bodyMedium =
      TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: color2);

  static const TextStyle bodySmall =
      TextStyle(fontWeight: FontWeight.w400, fontSize: 13.0, color: color3);

  static const String ratingKey = 'rating';
  static const String titleKey = 'title';
  static const String descriptionKey = 'description';
}
