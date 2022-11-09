import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/market_total.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_unit.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';

part 'reports_market.freezed.dart';
part 'reports_market.g.dart';

@freezed
class ReportsMarket with _$ReportsMarket {
  @JsonSerializable(includeIfNull: false)
  const factory ReportsMarket({
    MarketsType? iso,
    List<ReportsUnit>? units,
    @JsonKey(name: 'market_total') MarketTotal? marketTotal,
  }) = _ReportsMarket;

  factory ReportsMarket.fromJson(Map<String, dynamic> json) =>
      _$ReportsMarketFromJson(json);
}
