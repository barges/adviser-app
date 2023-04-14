import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'balance_response.g.dart';

@JsonSerializable(includeIfNull: false)
class BalanceResponse extends BaseResponse {
  final int? count;
  final double? result;

  const BalanceResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    this.count,
    this.result,
  });

  factory BalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$BalanceResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BalanceResponseToJson(this);
}
