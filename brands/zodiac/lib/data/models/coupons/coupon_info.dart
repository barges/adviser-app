// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_info.g.dart';
part 'coupon_info.freezed.dart';

@freezed
class CouponInfo with _$CouponInfo {
  const CouponInfo._();

  @JsonSerializable(
      includeIfNull: false,
      createToJson: true,
      explicitToJson: true,
      fieldRename: FieldRename.snake)
  const factory CouponInfo({
    int? couponId,
    int? count,
    int? status,
    String? name,
    String? code,
    String? image,
  }) = _CouponInfo;

  factory CouponInfo.fromJson(Map<String, dynamic> json) =>
      _$CouponInfoFromJson(json);
}
