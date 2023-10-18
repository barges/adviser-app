import 'package:flutter/material.dart';
import 'package:web_fonts/fonts/web_fonts_descriptor.dart';
import 'package:web_fonts/fonts/web_fonts_variant.dart';
import 'package:web_fonts/web_fonts.dart';

class NotoColorEmojiFont {
  static const _fontFamily = 'NotoColorEmoji';
  static bool _registered = false;

  static String get fontFamily {
    _getTextStyle(const TextStyle());
    return _fontFamily;
  }

  // register font files
  static register() {
    if (_registered) {
      return;
    }

    WebFonts.register(_fontFamily, {
      const WebFontsVariant(
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ): WebFontsFile(
        'https://github.com/googlefonts/noto-emoji/raw/main/fonts/NotoColorEmoji.ttf',
      ),
    });

    _registered = true;
  }

  static TextStyle _getTextStyle(TextStyle? textStyle) {
    register();

    return WebFonts.getTextStyle(_fontFamily, textStyle: textStyle);
  }
}
