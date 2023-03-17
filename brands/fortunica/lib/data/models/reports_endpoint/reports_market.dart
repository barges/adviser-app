// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fortunica/data/models/reports_endpoint/market_total.dart';
import 'package:fortunica/data/models/reports_endpoint/reports_unit.dart';

part 'reports_market.freezed.dart';
part 'reports_market.g.dart';

@freezed
class ReportsMarket with _$ReportsMarket {
  @JsonSerializable(includeIfNull: false)
  const factory ReportsMarket({
    String? iso,
    List<ReportsUnit>? units,
    @JsonKey(name: 'market_total') MarketTotal? marketTotal,
  }) = _ReportsMarket;

  factory ReportsMarket.fromJson(Map<String, dynamic> json) =>
      _$ReportsMarketFromJson(json);
}
