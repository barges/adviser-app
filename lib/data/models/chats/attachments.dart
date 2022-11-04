import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachments.freezed.dart';
part 'attachments.g.dart';

@freezed
class Attachments with _$Attachments {
  @JsonSerializable(includeIfNull: false)
  const factory Attachments({
    String? mime,
    String? url,
    String? meta,
  }) = _Attachments;

  factory Attachments.fromJson(Map<String, dynamic> json) =>
      _$AttachmentsFromJson(json);
}