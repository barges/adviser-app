import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_type.dart';

part 'answer_request.g.dart';

@JsonSerializable(includeIfNull: false)
class AnswerRequest {
  String? questionID;
  String? content;
  SessionsTypes? ritualID;
  List<Attachment>? attachments;

  AnswerRequest(
      {this.questionID, this.content, this.ritualID, this.attachments});

  factory AnswerRequest.fromJson(Map<String, dynamic> json) =>
      _$AnswerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerRequestToJson(this);
}
