import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../generated/assets/assets.gen.dart';
import '../../../generated/l10n.dart';

enum ChatItemType {
  @JsonValue("PRIVATE")
  private,
  @JsonValue("HISTORY")
  history,
  @JsonValue("PUBLIC")
  public,
  @JsonValue("RITUAL")
  ritual,
  @JsonValue("TEXT_ANSWER")
  textAnswer,
  all;

  String filterName(BuildContext context) {
    switch (this) {
      case ChatItemType.private:
        return SFortunica.of(context).privateQuestionsFortunica;
      case ChatItemType.ritual:
        return SFortunica.of(context).onlyPremiumProductsFortunica;
      case ChatItemType.history:
      case ChatItemType.public:
      case ChatItemType.textAnswer:
      case ChatItemType.all:
        return SFortunica.of(context).allFortunica;
    }
  }

  String get filterTypeName {
    switch (this) {
      case ChatItemType.private:
        return 'PRIVATE';
      case ChatItemType.ritual:
        return 'RITUAL';
      case ChatItemType.history:
      case ChatItemType.public:
      case ChatItemType.textAnswer:
      case ChatItemType.all:
        return 'ALL';
    }
  }

  String get iconPath {
    switch (this) {
      case ChatItemType.public:
        return Assets.vectors.sessionsTypes.public.path;
      case ChatItemType.private:
        return Assets.vectors.sessionsTypes.private.path;
      case ChatItemType.ritual:
        return Assets.vectors.sessionsTypes.ritual.path;
      default:
        return '';
    }
  }

  String typeName(BuildContext context) {
    switch (this) {
      case ChatItemType.private:
        return SFortunica.of(context).privateQuestionFortunica;
      case ChatItemType.ritual:
        return '${SFortunica.of(context).ritualFortunica} ${SFortunica.of(context).sessionFortunica}';
      case ChatItemType.public:
        return SFortunica.of(context).publicQuestionFortunica;
      default:
        return '';
    }
  }

  String unAnsweredMessage(BuildContext context) {
    switch (this) {
      case ChatItemType.private:
        return SFortunica.of(context).youHaveAPrivateMessageFortunica;
      case ChatItemType.ritual:
        return SFortunica.of(context).youHaveAnActiveSessionFortunica;
      default:
        return '';
    }
  }
}
