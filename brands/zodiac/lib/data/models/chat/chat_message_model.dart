// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/chat/product_box.dart';
import 'package:zodiac/data/models/chat/replied_message.dart';
import 'package:zodiac/data/models/enums/chat_message_type.dart';
import 'package:zodiac/data/models/enums/missed_message_action.dart';

part 'chat_message_model.g.dart';

part 'chat_message_model.freezed.dart';

@freezed
class ChatMessageModel with _$ChatMessageModel {
  const ChatMessageModel._();

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory ChatMessageModel({
    @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
    @Default(ChatMessageType.simple)
    ChatMessageType type,
    int? id,
    @JsonKey(fromJson: _dateFromSeconds, toJson: _dateToSeconds) DateTime? utc,
    int? timerReal,
    int? timerUser,
    int? chatId,
    String? message,
    @JsonKey(fromJson: _boolFromInt, toJson: _boolToInt)
    @Default(false)
    bool isRead,
    int? roomId,
    @JsonKey(name: 'productBox') ProductBox? productBox,
    String? price,
    int? status,
    String? icon,
    double? rating,
    int? couponId,
    int? tipsId,
    @JsonKey(name: 'me', fromJson: _boolFromInt, toJson: _boolToInt)
    @Default(false)
    bool isOutgoing,
    String? name,
    String? authorName,
    String? description,
    int? dateStart,
    int? dateExpire,
    @JsonKey(fromJson: _boolFromInt, toJson: _boolToInt)
    @Default(false)
    bool fromAdvisor,
    @JsonKey(unknownEnumValue: MissedMessageAction.none)
    MissedMessageAction? action,
    @JsonKey(name: 'main') String? mainImage,
    String? thumbnail,
    String? couponImage,
    String? image,
    String? path,
    int? length,
    RepliedMessage? repliedMessage,
    String? mid,
    bool? supportsReaction,
    @JsonKey(ignore: true) @Default(true) bool isDelivered,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);
}

ChatMessageType _typeFromJson(num? value) {
  int? type = value?.toInt();
  return ChatMessageType.typeFromInt(type);
}

int _typeToJson(ChatMessageType value) {
  return value.intFromType;
}

bool _boolFromInt(num? value) => value == 1;

int _boolToInt(bool value) => value ? 1 : 0;

DateTime? _dateFromSeconds(num? value) {
  if (value != null) {
    return DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000,
        isUtc: true);
  } else {
    return null;
  }
}

int? _dateToSeconds(DateTime? value) {
  if (value != null) {
    return value.millisecondsSinceEpoch ~/ 1000;
  } else {
    return null;
  }
}
