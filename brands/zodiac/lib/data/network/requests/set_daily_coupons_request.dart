import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'set_daily_coupons_request.g.dart';

@JsonSerializable(includeIfNull: false)
class SetDailyCouponsRequest extends AuthorizedRequest {
  List<int> coupons;

  SetDailyCouponsRequest({required this.coupons});

  factory SetDailyCouponsRequest.fromJson(Map<String, dynamic> json) =>
      _$SetDailyCouponsRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SetDailyCouponsRequestToJson(this);
}
