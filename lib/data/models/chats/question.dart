import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/client_information.dart';
import 'package:shared_advisor_interface/data/models/chats/questions_type.dart';

part 'question.freezed.dart';
part 'question.g.dart';

@freezed
class Question with _$Question {
  @JsonSerializable(includeIfNull: false)
  const factory Question({
    QuestionsType? type,
    String? clientName,
    String? createdAt,
    String? updatedAt,
    String? content,
    @JsonKey(name: '_id')
    final String? id,
    ClientInformation? clientInformation,
    List<dynamic>? attachments,
    String? clientID,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}
