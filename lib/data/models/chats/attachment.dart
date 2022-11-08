import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/meta.dart';

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
    Meta? meta,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);
}
