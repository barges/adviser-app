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
        return 'Private Questions';
      case QuestionsType.ritual:
        return 'Only Premium Products';
      case QuestionsType.history:
      case QuestionsType.public:
      case QuestionsType.all:
        return S.current.all;
    }
  }

  String get jsonValue {
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
