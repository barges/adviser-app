import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

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
        return S.of(context).privateQuestions;
      case ChatItemType.ritual:
        return S.of(context).onlyPremiumProducts;
      case ChatItemType.history:
      case ChatItemType.public:
      case ChatItemType.textAnswer:
      case ChatItemType.all:
        return S.of(context).all;
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
        return '${S.of(context).private} ${S.of(context).question}';
      case ChatItemType.ritual:
        return '${S.of(context).ritual} ${S.of(context).session}';
      case ChatItemType.public:
        return '${S.of(context).public} ${S.of(context).question}';
      default:
        return '';
    }
  }

  String unAnsweredMessage(BuildContext context) {
    switch (this) {
      case ChatItemType.private:
        return S.of(context).youHaveAPrivateMessage;
      case ChatItemType.ritual:
        return S.of(context).youHaveARitualRequest;
      default:
        return '';
    }
  }
}
