import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:fortunica/generated/l10n.dart';

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
  undefined;

  String sessionName(BuildContext context) {
    switch (this) {
      case SessionsTypes.public:
        return SFortunica.of(context).publicFortunica;
      case SessionsTypes.private:
        return SFortunica.of(context).privateFortunica;
      case SessionsTypes.tarot:
        return SFortunica.of(context).tarotFortunica;
      case SessionsTypes.palmreading:
        return SFortunica.of(context).palmReadingFortunica;
      case SessionsTypes.astrology:
        return SFortunica.of(context).astrologyFortunica;
      case SessionsTypes.reading360:
        return SFortunica.of(context).reading360Fortunica;
      case SessionsTypes.aurareading:
        return SFortunica.of(context).soulmateReadingFortunica;
      case SessionsTypes.lovecrushreading:
        return SFortunica.of(context).loveCrushReadingFortunica;
      case SessionsTypes.ritual:
        return SFortunica.of(context).ritualFortunica;
      case SessionsTypes.tipsLow:
      case SessionsTypes.tipsMedium:
      case SessionsTypes.tipsHigh:
      case SessionsTypes.tips:
        return SFortunica.of(context).tipsFortunica;
      case SessionsTypes.undefined:
        return '';
    }
  }

  String sessionNameForStatistics(context) {
    switch (this) {
      case SessionsTypes.public:
        return SFortunica.of(context).publicQuestionFortunica;
      case SessionsTypes.private:
        return SFortunica.of(context).privateQuestionFortunica;
      case SessionsTypes.tarot:
        return SFortunica.of(context).tarotSessionsFortunica;
      case SessionsTypes.palmreading:
        return SFortunica.of(context).palmReadingSessionsFortunica;
      case SessionsTypes.astrology:
        return SFortunica.of(context).astrologySessionsFortunica;
      case SessionsTypes.reading360:
        return SFortunica.of(context).reading360SessionsFortunica;
      case SessionsTypes.aurareading:
        return SFortunica.of(context).soulmateReadingSessionsFortunica;
      case SessionsTypes.lovecrushreading:
        return SFortunica.of(context).loveCrushReadingSessionsFortunica;
      case SessionsTypes.ritual:
        return SFortunica.of(context).ritualSessionsFortunica;
      case SessionsTypes.tipsLow:
      case SessionsTypes.tipsMedium:
      case SessionsTypes.tipsHigh:
      case SessionsTypes.tips:
        return sessionName(context);
      case SessionsTypes.undefined:
        return '';
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
      case SessionsTypes.undefined:
        return '';
    }
  }

  static const List<String> actualSessionsTypes = [
    'public',
    'private',
    'tarot',
    'palmreading',
    'astrology',
    'reading360',
    'aurareading',
    'lovecrushreading',
    'ritual',
    'tipsLow',
    'tipsMedium',
    'tipsHigh',
    'tips',
  ];

  static SessionsTypes typeFromString(String? type) {
    switch (type) {
      case 'public':
        return SessionsTypes.public;
      case 'private':
        return SessionsTypes.private;
      case 'tarot':
        return SessionsTypes.tarot;
      case 'palmreading':
        return SessionsTypes.palmreading;
      case 'astrology':
        return SessionsTypes.astrology;
      case 'reading360':
        return SessionsTypes.reading360;
      case 'aurareading':
        return SessionsTypes.aurareading;
      case 'lovecrushreading':
        return SessionsTypes.lovecrushreading;
      case 'ritual':
        return SessionsTypes.ritual;
      case 'tipsLow':
        return SessionsTypes.tipsLow;
      case 'tipsMedium':
        return SessionsTypes.tipsMedium;
      case 'tipsHigh':
        return SessionsTypes.tipsHigh;
      case 'tips':
        return SessionsTypes.tips;
      default:
        return SessionsTypes.undefined;
    }
  }
}
