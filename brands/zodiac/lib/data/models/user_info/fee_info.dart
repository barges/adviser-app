// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'fee_info.g.dart';
part 'fee_info.freezed.dart';

@freezed
class FeeInfo with _$FeeInfo {
  const FeeInfo._();

  @JsonSerializable(includeIfNull: false, createToJson: true)
  const factory FeeInfo({
    @JsonKey(name: 'have_call') int? callEnabled,
    @JsonKey(name: 'call_fee') double? callFee,
    @JsonKey(name: 'have_chat') int? chatEnabled,
    @JsonKey(name: 'chat_fee') double? chatFee,
  }) = _FeeInfo;

  factory FeeInfo.fromJson(Map<String, dynamic> json) =>
      _$FeeInfoFromJson(json);
}
