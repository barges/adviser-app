// ignore_for_file: invalid_annotation_target

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fortunica/data/models/chats/meta.dart';
import 'package:fortunica/data/models/enums/attachment_type.dart';

part 'attachment.freezed.dart';
part 'attachment.g.dart';

@freezed
class Attachment with _$Attachment {
  const Attachment._();
  @JsonSerializable(includeIfNull: false)
  const factory Attachment({
    String? mime,
    String? attachment,
    String? url,
    @JsonKey(fromJson: metaFromJson) Meta? meta,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);

  AttachmentType get type {
    String? typeName = mime?.split('/').firstOrNull;
    if (typeName == AttachmentType.audio.name) {
      return AttachmentType.audio;
    } else if (typeName == AttachmentType.video.name) {
      return AttachmentType.video;
    } else {
      return AttachmentType.image;
    }
  }
}

Meta? metaFromJson(dynamic jsonValue) {
  return jsonValue is Map<String, dynamic> ? Meta.fromJson(jsonValue) : null;
}