import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment.freezed.dart';
part 'attachment.g.dart';

@freezed
class Attachment with _$Attachment {
  @JsonSerializable(includeIfNull: false)
  const factory Attachment({
    @JsonKey(name: '_id') String? id,
    String? mime,
    String? attachment,
    String? url,
    dynamic meta,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);
}
