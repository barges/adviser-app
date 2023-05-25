// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
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
    String? lastMessageType,
    int? dateLastUpdate,
    int? id,
    String? name,
    @JsonKey(fromJson: _statusFromJson) ZodiacUserStatus? status,
    String? avatar,
  }) = _ZodiacChatsListItem;

  factory ZodiacChatsListItem.fromJson(Map<String, dynamic> json) =>
      _$ZodiacChatsListItemFromJson(json);

  bool get isMissed => lastMessageType == '17';

  bool get haveUnreadedMessages => unreadCount != null && unreadCount! > 0;

  bool get isAudio => lastMessageType == '21';
}

ZodiacUserStatus _statusFromJson(num? value) {
  int? status = value?.toInt();
  return ZodiacUserStatus.statusFromInt(status);
}
