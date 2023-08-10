// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/coupons/coupon_info.dart';

part 'coupons_category.g.dart';
part 'coupons_category.freezed.dart';

@freezed
class CouponsCategory with _$CouponsCategory {
  const CouponsCategory._();

  @JsonSerializable(
      includeIfNull: false,
      createToJson: true,
      explicitToJson: true,
      fieldRename: FieldRename.snake)
  const factory CouponsCategory({
    String? type,
    String? label,
    List<CouponInfo>? coupons,
  }) = _CouponsCategory;

  factory CouponsCategory.fromJson(Map<String, dynamic> json) =>
      _$CouponsCategoryFromJson(json);
}
