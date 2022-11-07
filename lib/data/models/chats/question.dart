import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/client_information.dart';
import 'package:shared_advisor_interface/data/models/chats/questions_type.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';
import 'package:shared_advisor_interface/data/models/chats/conversation_item.dart';

part 'question.freezed.dart';
part 'question.g.dart';

@freezed
class Question extends ConversationItem with _$Question {
  @JsonSerializable(includeIfNull: false)
  const factory Question({
    @JsonKey(name: '_id') final String? id,
    QuestionsType? type,
    SessionsTypes? ritualIdentifier,
    String? clientID,
    String? clientName,
    String? createdAt,
    String? updatedAt,
    String? content,
    ClientInformation? clientInformation,
    List<Attachment>? attachments,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}
