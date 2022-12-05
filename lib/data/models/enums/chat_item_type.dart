import 'package:json_annotation/json_annotation.dart';
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
}
