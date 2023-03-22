import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/user_info/fee_info.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'price_settings_response.g.dart';

@JsonSerializable(includeIfNull: false)
class PriceSettingsResponse extends BaseResponse {
  final int? count;
  final FeeInfo? result;

  const PriceSettingsResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.count,
    this.result,
  });

  factory PriceSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$PriceSettingsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PriceSettingsResponseToJson(this);
}
