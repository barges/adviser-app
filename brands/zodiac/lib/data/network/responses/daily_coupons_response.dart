import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/coupons/coupon_info.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'daily_coupons_response.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class DailyCouponsResponse extends BaseResponse {
  final List<CouponInfo>? coupons;
  final int? limit;
  final bool? isEnabled;
  final bool? isRenewalEnabled;

  const DailyCouponsResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    this.coupons,
    this.limit,
    this.isEnabled,
    this.isRenewalEnabled,
  });

  factory DailyCouponsResponse.fromJson(Map<String, dynamic> json) =>
      _$DailyCouponsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DailyCouponsResponseToJson(this);
}
