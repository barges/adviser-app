import 'package:flutter/painting.dart';

const Color primary = Color(0xFF721C70);
const Color secondary = Color(0xFF26264E);

const Color color2 = Color(0xFF322C32);
const Color color3 = Color(0xFFAAA2AA);

const Color inactive1 = Color(0xFF878787);
const Color inactive2 = Color(0xFFBDBDBD);

const Color white = Color(0xFFFFFFFF);

TextStyle? appBarTitleStyle =
    const TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: color2);

TextStyle? displayLarge = const TextStyle(
    fontSize: 16.0, fontWeight: FontWeight.w400, color: primary);

TextStyle? bodyMedium =
    const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: color2);

TextStyle? bodySmall =
    const TextStyle(fontWeight: FontWeight.w400, fontSize: 13.0, color: color3);

const ratingKey = 'rating';
const titleKey = 'title';
const descriptionKey = 'description';
