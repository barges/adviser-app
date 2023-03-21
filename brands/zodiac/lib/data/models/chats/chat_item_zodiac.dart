// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_item_zodiac.g.dart';
part 'chat_item_zodiac.freezed.dart';

@freezed
class ZodiacChatsListItem with _$ZodiacChatsListItem {
  const ZodiacChatsListItem._();

  @JsonSerializable(includeIfNull: false)
  const factory ZodiacChatsListItem({
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'last_message') String? lastMessage,
    @JsonKey(name: 'is_banned') String? isBanned,
    @JsonKey(name: 'unread_count') int? unreadCount,
    @JsonKey(name: 'last_message_type') String? lastMessageType,
    @JsonKey(name: 'date_last_update') int? dateLastUpdate,
    int? id,
    String? name,
    int? status,
    String? avatar,
  }) = _ZodiacChatsListItem;

  factory ZodiacChatsListItem.fromJson(Map<String, dynamic> json) =>
      _$ZodiacChatsListItemFromJson(json);

  bool get isMissed => lastMessageType == '17';

  bool get haveUnreadedMessages => unreadCount != null && unreadCount! > 0;
}
