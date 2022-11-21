import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

enum ZodiacSign {
  aquarius,
  aries,
  cancer,
  capricorn,
  gemini,
  leo,
  libra,
  pisces,
  sagittarius,
  scorpio,
  taurus,
  virgo
}

extension ZodiacSignExt on ZodiacSign {
  String imagePath(BuildContext context) {
    return Utils.isDarkMode(context) ? imagePathDark : imagePathLight;
  }

  String get imagePathLight {
    switch (this) {
      case ZodiacSign.aquarius:
        return Assets.vectors.zodiacLight.aquarius.path;
      case ZodiacSign.aries:
        return Assets.vectors.zodiacLight.aries.path;
      case ZodiacSign.cancer:
        return Assets.vectors.zodiacLight.cancer.path;
      case ZodiacSign.capricorn:
        return Assets.vectors.zodiacLight.capricorn.path;
      case ZodiacSign.gemini:
        return Assets.vectors.zodiacLight.gemini.path;
      case ZodiacSign.leo:
        return Assets.vectors.zodiacLight.leo.path;
      case ZodiacSign.libra:
        return Assets.vectors.zodiacLight.libra.path;
      case ZodiacSign.pisces:
        return Assets.vectors.zodiacLight.pisces.path;
      case ZodiacSign.sagittarius:
        return Assets.vectors.zodiacLight.sagittarius.path;
      case ZodiacSign.scorpio:
        return Assets.vectors.zodiacLight.scorpio.path;
      case ZodiacSign.taurus:
        return Assets.vectors.zodiacLight.taurus.path;
      case ZodiacSign.virgo:
        return Assets.vectors.zodiacLight.virgo.path;
    }
  }

  String get imagePathDark {
    switch (this) {
      case ZodiacSign.aquarius:
        return Assets.vectors.zodiacDark.aquarius.path;
      case ZodiacSign.aries:
        return Assets.vectors.zodiacDark.aries.path;
      case ZodiacSign.cancer:
        return Assets.vectors.zodiacDark.cancer.path;
      case ZodiacSign.capricorn:
        return Assets.vectors.zodiacDark.capricorn.path;
      case ZodiacSign.gemini:
        return Assets.vectors.zodiacDark.gemini.path;
      case ZodiacSign.leo:
        return Assets.vectors.zodiacDark.leo.path;
      case ZodiacSign.libra:
        return Assets.vectors.zodiacDark.libra.path;
      case ZodiacSign.pisces:
        return Assets.vectors.zodiacDark.pisces.path;
      case ZodiacSign.sagittarius:
        return Assets.vectors.zodiacDark.sagittarius.path;
      case ZodiacSign.scorpio:
        return Assets.vectors.zodiacDark.scorpio.path;
      case ZodiacSign.taurus:
        return Assets.vectors.zodiacDark.taurus.path;
      case ZodiacSign.virgo:
        return Assets.vectors.zodiacDark.virgo.path;
    }
  }

  String get iconPath {
    switch (this) {
      case ZodiacSign.aquarius:
        return Assets.vectors.horoscopes.aquarius.path;
      case ZodiacSign.aries:
        return Assets.vectors.horoscopes.aries.path;
      case ZodiacSign.cancer:
        return Assets.vectors.horoscopes.cancer.path;
      case ZodiacSign.capricorn:
        return Assets.vectors.horoscopes.capricorn.path;
      case ZodiacSign.gemini:
        return Assets.vectors.horoscopes.gemini.path;
      case ZodiacSign.leo:
        return Assets.vectors.horoscopes.leo.path;
      case ZodiacSign.libra:
        return Assets.vectors.horoscopes.libra.path;
      case ZodiacSign.pisces:
        return Assets.vectors.horoscopes.pisces.path;
      case ZodiacSign.sagittarius:
        return Assets.vectors.horoscopes.sagittarius.path;
      case ZodiacSign.scorpio:
        return Assets.vectors.horoscopes.scorpio.path;
      case ZodiacSign.taurus:
        return Assets.vectors.horoscopes.taurus.path;
      case ZodiacSign.virgo:
        return Assets.vectors.horoscopes.virgo.path;
    }
  }
}
