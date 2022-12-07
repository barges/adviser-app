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

  String get filterName {
    switch (this) {
      case ChatItemType.private:
        return S.current.privateQuestions;
      case ChatItemType.ritual:
        return S.current.onlyPremiumProducts;
      case ChatItemType.history:
      case ChatItemType.public:
      case ChatItemType.textAnswer:
      case ChatItemType.all:
        return S.current.all;
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
      default:
        return '';
    }
  }

  String get typeName {
    switch (this) {
      case ChatItemType.private:
        return 'Private question';
      case ChatItemType.ritual:
        return 'Ritual session';
      case ChatItemType.public:
        return 'Public question';
      default:
        return '';
    }
  }
}
