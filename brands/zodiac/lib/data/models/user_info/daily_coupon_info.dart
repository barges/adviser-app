// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_coupon_info.g.dart';
part 'daily_coupon_info.freezed.dart';

@freezed
class DailyCouponInfo with _$DailyCouponInfo {
  const DailyCouponInfo._();

  @JsonSerializable(
      includeIfNull: false,
      createToJson: true,
      explicitToJson: true,
      fieldRename: FieldRename.snake)
  const factory DailyCouponInfo({
    int? couponId,
    int? count,
    int? status,
    String? image,
  }) = _DailyCouponInfo;

  factory DailyCouponInfo.fromJson(Map<String, dynamic> json) =>
      _$DailyCouponInfoFromJson(json);
}
