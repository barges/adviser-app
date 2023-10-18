import 'package:json_annotation/json_annotation.dart';

import '../../models/chats/attachment.dart';

part 'answer_request.g.dart';

@JsonSerializable(includeIfNull: false)
class AnswerRequest {
  String? questionID;
  String? content;
  String? ritualID;
  List<Attachment>? attachments;

  AnswerRequest(
      {this.questionID, this.content, this.ritualID, this.attachments});

  factory AnswerRequest.fromJson(Map<String, dynamic> json) =>
      _$AnswerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerRequestToJson(this);
}
