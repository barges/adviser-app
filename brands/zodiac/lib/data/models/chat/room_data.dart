// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_data.g.dart';

part 'room_data.freezed.dart';

@freezed
class RoomData with _$RoomData {
  const RoomData._();

  @JsonSerializable(
    includeIfNull: false,
    fieldRename: FieldRename.snake,
  )
  const factory RoomData({
    String? id,
    String? type,
    dynamic fee,
    int? startTimer,
    @Default(false)
    bool trial,
  }) = _RoomData;

  factory RoomData.fromJson(Map<String, dynamic> json) =>
      _$RoomDataFromJson(json);
}
