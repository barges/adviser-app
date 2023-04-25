// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_context.g.dart';

part 'message_context.freezed.dart';

@freezed
class MessageContext with _$MessageContext {
  const MessageContext._();

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory MessageContext({
    int? roomId,
    int? length,
    String? path,
  }) = _MessageContext;

  factory MessageContext.fromJson(Map<String, dynamic> json) =>
      _$MessageContextFromJson(json);
}
