// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/chat/product_data.dart';
import 'package:zodiac/data/models/chat/room_data.dart';
import 'package:zodiac/data/models/chat/session_data.dart';
import 'package:zodiac/data/models/chat/user_data.dart';

part 'enter_room_data.g.dart';

part 'enter_room_data.freezed.dart';

@freezed
class EnterRoomData with _$EnterRoomData {
  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
  )
  const factory EnterRoomData({
    RoomData? roomData,
    UserData? userData,
    UserData? expertData,
    SessionData? sessionData,
    ProductData? productData,
    @JsonKey(
      name: 'active_chat',
    )
    int? activeChat,
    @JsonKey(
      name: 'new_status_algo',
    )
    int? newStatusAlgo,
    @JsonKey(
      name: 'is_available_audio_message',
    )
    @Default(false)
    bool isAvailableAudioMessage
  }) = _EnterRoomData;

  factory EnterRoomData.fromJson(Map<String, dynamic> json) =>
      _$EnterRoomDataFromJson(json);
}
