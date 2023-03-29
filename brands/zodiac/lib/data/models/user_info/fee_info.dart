// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'fee_info.g.dart';

part 'fee_info.freezed.dart';

@freezed
class FeeInfo with _$FeeInfo {
  const FeeInfo._();

  @JsonSerializable(
    includeIfNull: false,
    fieldRename: FieldRename.snake,
  )
  const factory FeeInfo({
    @JsonKey(name: 'have_call') int? callEnabled,
    double? callFee,
    @JsonKey(name: 'have_chat') int? chatEnabled,
    double? chatFee,
  }) = _FeeInfo;

  factory FeeInfo.fromJson(Map<String, dynamic> json) =>
      _$FeeInfoFromJson(json);
}
