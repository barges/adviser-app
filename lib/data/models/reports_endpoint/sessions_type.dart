import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

enum SessionsTypes {
  public,
  private,
  tarot,
  palmreading,
  astrology,
  reading360,
  aurareading,
  lovecrushreading,
  ritual,
  tipsLow,
  tipsMedium,
  tipsHigh,
}

extension SessionsTypeExt on SessionsTypes {
  String get sessionName {
    switch (this) {
      case SessionsTypes.public:
        return 'Public Questions';
      case SessionsTypes.private:
        return 'Private Questions';
      case SessionsTypes.tarot:
        return 'Tarot Sessions';
      case SessionsTypes.palmreading:
        return 'Palm Reading Sessions';
      case SessionsTypes.astrology:
        return 'Astrology Sessions';
      case SessionsTypes.reading360:
        return '360° Reading Session';
      case SessionsTypes.aurareading:
        return 'Aura Reading Sessions';
      case SessionsTypes.lovecrushreading:
        return 'Love Crush Reading Session';
      case SessionsTypes.ritual:
        return 'Ritual Sessions';
      case SessionsTypes.tipsLow:
      case SessionsTypes.tipsMedium:
      case SessionsTypes.tipsHigh:
        return 'Tips';
    }
  }

  String get iconPath {
    switch (this) {
      case SessionsTypes.public:
        return Assets.vectors.sessionsTypes.public.path;
      case SessionsTypes.private:
        return Assets.vectors.sessionsTypes.private.path;
      case SessionsTypes.tarot:
        return Assets.vectors.sessionsTypes.tarot.path;
      case SessionsTypes.palmreading:
        return Assets.vectors.sessionsTypes.palmreading.path;
      case SessionsTypes.astrology:
        return Assets.vectors.sessionsTypes.astrology.path;
      case SessionsTypes.reading360:
        return Assets.vectors.sessionsTypes.reading360.path;
      case SessionsTypes.aurareading:
        return Assets.vectors.sessionsTypes.aurareading.path;
      case SessionsTypes.lovecrushreading:
        return Assets.vectors.sessionsTypes.lovecrushreading.path;
      case SessionsTypes.ritual:
        return Assets.vectors.sessionsTypes.ritual.path;
      case SessionsTypes.tipsLow:
      case SessionsTypes.tipsMedium:
      case SessionsTypes.tipsHigh:
        return Assets.vectors.sessionsTypes.tips.path;
    }
  }
}
