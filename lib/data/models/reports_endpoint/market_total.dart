import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_total.freezed.dart';
part 'market_total.g.dart';

@freezed
class MarketTotal with _$MarketTotal {

  @JsonSerializable(includeIfNull: false)
  const factory MarketTotal({
    double? amount,

  }) = _MarketTotal;

  factory MarketTotal.fromJson(Map<String, dynamic> json) =>
      _$MarketTotalFromJson(json);
}