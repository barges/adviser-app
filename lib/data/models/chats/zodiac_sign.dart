import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

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
  String get getZodiacSignImagePath {
    switch (this) {
      case ZodiacSign.aquarius:
        return Assets.vectors.zodiac.aquarius.path;
      case ZodiacSign.aries:
        return Assets.vectors.zodiac.aries.path;
      case ZodiacSign.cancer :
        return Assets.vectors.zodiac.cancer.path;
      case ZodiacSign.capricorn :
        return Assets.vectors.zodiac.capricorn.path;
      case ZodiacSign.gemini :
        return Assets.vectors.zodiac.gemini.path;
      case ZodiacSign.leo :
        return Assets.vectors.zodiac.leo.path;
      case ZodiacSign.libra :
        return Assets.vectors.zodiac.libra.path;
      case ZodiacSign.pisces :
        return Assets.vectors.zodiac.pisces.path;
      case ZodiacSign.sagittarius :
        return Assets.vectors.zodiac.sagittarius.path;
      case ZodiacSign.scorpio :
        return Assets.vectors.zodiac.scorpio.path;
      case ZodiacSign.taurus :
        return Assets.vectors.zodiac.taurus.path;
      case ZodiacSign.virgo :
        return Assets.vectors.zodiac.virgo.path;
    }
  }
}