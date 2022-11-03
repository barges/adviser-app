import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/network/requests/attachment_request.dart';

part 'answer_request.g.dart';

@JsonSerializable(includeIfNull: false)
class AnswerRequest {
  String? questionID;
  String? content;
  String? ritualID;
  List<AttachmentRequest>? attachments;

  AnswerRequest(
      {this.questionID, this.content, this.ritualID, this.attachments});

  factory AnswerRequest.fromJson(Map<String, dynamic> json) =>
      _$AnswerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerRequestToJson(this);
}
