import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'advice_tips_response.g.dart';

@JsonSerializable(includeIfNull: false)
class AdviceTipsResponse extends BaseResponse {
  final List<String>? result;

  const AdviceTipsResponse(
      {super.status, super.errorCode, super.errorMsg, this.result});

  factory AdviceTipsResponse.fromJson(Map<String, dynamic> json) =>
      _$AdviceTipsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AdviceTipsResponseToJson(this);
}
