import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

enum QuestionsType {
  @JsonValue("PRIVATE")
  private,
  @JsonValue("HISTORY")
  history,
  @JsonValue("PUBLIC")
  public,
  @JsonValue("RITUAL")
  ritual,
  all
}

extension QuestionsTypeExt on QuestionsType {
  String get filterName {
    switch (this) {
      case QuestionsType.private:
        return S.current.privateQuestions;
      case QuestionsType.ritual:
        return S.current.onlyPremiumProducts;
      case QuestionsType.history:
      case QuestionsType.public:
      case QuestionsType.all:
        return S.current.all;
    }
  }

  String get filterTypeName {
    switch (this) {
      case QuestionsType.private:
        return 'PRIVATE';
      case QuestionsType.ritual:
        return 'RITUAL';
      case QuestionsType.history:
      case QuestionsType.public:
      case QuestionsType.all:
        return 'ALL';
    }
  }
}
