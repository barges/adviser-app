import 'package:json_annotation/json_annotation.dart';

enum QuestionsType {
  @JsonValue("PRIVATE")
  private,
  @JsonValue("HISTORY")
  history,
  @JsonValue("PUBLIC")
  public,
  @JsonValue("RITUAL")
  ritual,
}

extension QuestionsTypeExtension on QuestionsType {
  String get name {
    switch (this) {
      case QuestionsType.private:
        return 'Private';
      case QuestionsType.history:
        return 'History';
      case QuestionsType.public:
        return 'Public';
      case QuestionsType.ritual:
        return 'Ritual';
    }
  }
}
