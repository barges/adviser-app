import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/user_info/brand_and_locales_model.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'brand_locales_response.g.dart';

@JsonSerializable(includeIfNull: false)
class BrandLocalesResponse extends BaseResponse {
  final List<BrandAndLocalesModel>? result;

  const BrandLocalesResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    this.result,
  });

  factory BrandLocalesResponse.fromJson(Map<String, dynamic> json) =>
      _$BrandLocalesResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BrandLocalesResponseToJson(this);
}
