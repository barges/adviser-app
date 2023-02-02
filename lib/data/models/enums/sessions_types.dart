import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

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
        return S.of(context).public;
      case SessionsTypes.private:
        return S.of(context).private;
      case SessionsTypes.tarot:
        return S.of(context).tarot;
      case SessionsTypes.palmreading:
        return S.of(context).palmReading;
      case SessionsTypes.astrology:
        return S.of(context).astrology;
      case SessionsTypes.reading360:
        return S.of(context).reading360;
      case SessionsTypes.aurareading:
        return S.of(context).soulmateReading;
      case SessionsTypes.lovecrushreading:
        return S.of(context).loveCrushReading;
      case SessionsTypes.ritual:
        return S.of(context).ritual;
      case SessionsTypes.tipsLow:
      case SessionsTypes.tipsMedium:
      case SessionsTypes.tipsHigh:
      case SessionsTypes.tips:
        return S.of(context).tips;
      case SessionsTypes.undefined:
        return '';
    }
  }

  String sessionNameForStatistics(context) {
    switch (this) {
      case SessionsTypes.public:
      case SessionsTypes.private:
        return '${sessionName(context)} ${S.of(context).questions}';
      case SessionsTypes.tarot:
      case SessionsTypes.palmreading:
      case SessionsTypes.astrology:
      case SessionsTypes.reading360:
      case SessionsTypes.aurareading:
      case SessionsTypes.lovecrushreading:
      case SessionsTypes.ritual:
        return '${sessionName(context)} ${S.of(context).sessions}';
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
}
