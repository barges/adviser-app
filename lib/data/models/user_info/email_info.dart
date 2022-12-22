// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_info.freezed.dart';

part 'email_info.g.dart';

@freezed
class EmailInfo with _$EmailInfo {
  @JsonSerializable(includeIfNull: false)
  const factory EmailInfo({
    String? address,
    @JsonKey(name: '_id')
    String? id,
    bool? safeToSend,
    String? reason,
    bool? verificationPerformed,
    DateTime? date,
  }) = _EmailInfo;

  factory EmailInfo.fromJson(Map<String, dynamic> json) =>
      _$EmailInfoFromJson(json);
}