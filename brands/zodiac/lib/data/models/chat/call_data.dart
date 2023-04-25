// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/chat/user_data.dart';

part 'call_data.g.dart';

part 'call_data.freezed.dart';

@freezed
class CallData with _$CallData{
  const CallData._();

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
  )
  const factory CallData({
    UserData? userData,
    UserData? expertData,
    @JsonKey(name: 'new_status_algo')
    int? newStatusAlgo,
    @JsonKey(name: 'session_id')
    String? sessionId,
    @JsonKey(name: 'chat_type')
    String? chatType,
  }) = _CallData;

  factory CallData.fromJson(Map<String, dynamic> json) =>
      _$CallDataFromJson(json);
}
