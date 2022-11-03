import 'package:json_annotation/json_annotation.dart';

part 'attachment_request.g.dart';

@JsonSerializable(includeIfNull: false)
class AttachmentRequest {
  final String? mime;
  final String? attachment;
  final String? meta;

  AttachmentRequest({this.mime, this.attachment, this.meta});

  factory AttachmentRequest.fromJson(Map<String, dynamic> json) =>
      _$AttachmentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentRequestToJson(this);
}
