import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/questions_type.dart';
import 'package:shared_advisor_interface/data/models/chats/conversation_item.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';

part 'answer.freezed.dart';
part 'answer.g.dart';

@freezed
class Answer extends ConversationItem with _$Answer {
  @JsonSerializable(includeIfNull: false)
  const factory Answer({
    @JsonKey(name: '_type') QuestionsType? type,
    SessionsTypes? ritualIdentifier,
    String? questionID,
    String? content,
    String? createdAt,
    QuestionsType? questionType,
    List<Attachment>? attachments,
  }) = _Answer;

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);
}
