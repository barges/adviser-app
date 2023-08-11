// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/enums/chat_message_type.dart';
import 'package:zodiac/data/models/enums/message_type.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';

part 'chat_item_zodiac.g.dart';

part 'chat_item_zodiac.freezed.dart';

@freezed
class ZodiacChatsListItem with _$ZodiacChatsListItem {
  const ZodiacChatsListItem._();

  @JsonSerializable(
    includeIfNull: false,
    fieldRename: FieldRename.snake,
  )
  const factory ZodiacChatsListItem({
    int? userId,
    String? lastMessage,
    String? isBanned,
    int? unreadCount,
    @JsonKey(fromJson: _typeFromJson) ChatMessageType? lastMessageType,
    int? dateLastUpdate,
    int? id,
    String? name,
    @JsonKey(fromJson: _statusFromJson) ZodiacUserStatus? status,
    String? avatar,
    @JsonKey(fromJson: MessageType.fromJson) MessageType? type,
  }) = _ZodiacChatsListItem;

  factory ZodiacChatsListItem.fromJson(Map<String, dynamic> json) =>
      _$ZodiacChatsListItemFromJson(json);

  bool get isMissed => lastMessageType == ChatMessageType.missed;

  bool get haveUnreadedMessages => unreadCount != null && unreadCount! > 0;

  bool get isAudio => lastMessageType == ChatMessageType.audio;
}

ZodiacUserStatus _statusFromJson(num? value) {
  int? status = value?.toInt();
  return ZodiacUserStatus.statusFromInt(status);
}

ChatMessageType _typeFromJson(dynamic value) {
  String type = value.toString();
  return ChatMessageType.typeFromString(type);
}
