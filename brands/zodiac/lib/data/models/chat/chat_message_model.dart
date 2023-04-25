// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/chat/product_box.dart';
import 'package:zodiac/data/models/chat/replied_message.dart';
import 'package:zodiac/data/models/enums/chat_message_type.dart';

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
    int? utc,
    int? timerReal,
    int? timerUser,
    int? chatId,
    String? message,
    @JsonKey(fromJson: _boolFromInt, toJson: _boolToInt)
    @Default(false)
        bool isRead,
    int? roomId,
    @JsonKey(name: 'productBox') ProductBox? productBox,
    double? price,
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
    String? action,
    @JsonKey(name: 'main') String? mainImage,
    String? thumbnail,
    String? couponImage,
    String? image,
    String? path,
    int? length,
    RepliedMessage? repliedMessage,
    String? mid,
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
