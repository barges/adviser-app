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
  tips,
}

extension SessionsTypeExt on SessionsTypes {
  String get sessionName {
    switch (this) {
      case SessionsTypes.public:
        return 'Public';
      case SessionsTypes.private:
        return 'Private';
      case SessionsTypes.tarot:
        return 'Tarot';
      case SessionsTypes.palmreading:
        return 'Palm';
      case SessionsTypes.astrology:
        return 'Astrology';
      case SessionsTypes.reading360:
        return '360° Reading';
      case SessionsTypes.aurareading:
        return 'Aura Reading';
      case SessionsTypes.lovecrushreading:
        return 'Love Crush Reading';
      case SessionsTypes.ritual:
        return 'Ritual';
      case SessionsTypes.tipsLow:
      case SessionsTypes.tipsMedium:
      case SessionsTypes.tipsHigh:
      case SessionsTypes.tips:
        return 'Tips';
    }
  }

  String get sessionNameForStatistics {
    switch (this) {
      case SessionsTypes.public:
      case SessionsTypes.private:
        return '$sessionName Questions';
      case SessionsTypes.tarot:
      case SessionsTypes.palmreading:
      case SessionsTypes.astrology:
      case SessionsTypes.reading360:
      case SessionsTypes.aurareading:
      case SessionsTypes.lovecrushreading:
      case SessionsTypes.ritual:
        return '$sessionName Sessions';
      case SessionsTypes.tipsLow:
      case SessionsTypes.tipsMedium:
      case SessionsTypes.tipsHigh:
      case SessionsTypes.tips:
        return sessionName;
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
      case SessionsTypes.tips:
        return Assets.vectors.sessionsTypes.tips.path;
    }
  }
}
