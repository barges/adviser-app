// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_data.g.dart';

part 'session_data.freezed.dart';

@freezed
class SessionData with _$SessionData {
  @JsonSerializable(
    includeIfNull: false,
  )
  const factory SessionData({
    String? id,
  }) = _SessionData;

  factory SessionData.fromJson(Map<String, dynamic> json) =>
      _$SessionDataFromJson(json);
}
