// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/chat/user_data.dart';

part 'end_chat_data.g.dart';

part 'end_chat_data.freezed.dart';

@freezed
class EndChatData with _$EndChatData{
  const EndChatData._();

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory EndChatData({
    @Default(false)
    bool offlineSession,
    int? roomTimer,
    @Default(false)
    bool sendMessage,
    @Default(false)
    bool showReview,
    String? location,
    @JsonKey(ignore: true)
    int? opponentId,
  }) = _EndChatData;

  factory EndChatData.fromJson(Map<String, dynamic> json) =>
      _$EndChatDataFromJson(json);
}
