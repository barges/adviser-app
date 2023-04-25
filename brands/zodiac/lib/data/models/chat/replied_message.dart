// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/chat/message_context.dart';
import 'package:zodiac/data/models/enums/chat_message_type.dart';

part 'replied_message.g.dart';

part 'replied_message.freezed.dart';

@freezed
class RepliedMessage with _$RepliedMessage {
  const RepliedMessage._();

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory RepliedMessage({
  @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
  @Default(ChatMessageType.simple)
  ChatMessageType type,
  MessageContext? context,
    String? text,
    String? repliedUserName,
  }) = _RepliedMessage;

  factory RepliedMessage.fromJson(Map<String, dynamic> json) =>
      _$RepliedMessageFromJson(json);
}

ChatMessageType _typeFromJson(num? value) {
  int? type = value?.toInt();
  return ChatMessageType.typeFromInt(type);
}

int _typeToJson(ChatMessageType value) {
  return value.intFromType;
}


