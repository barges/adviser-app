import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/market_total.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_unit.dart';

part 'reports_total.freezed.dart';

part 'reports_total.g.dart';

@freezed
class ReportsTotal with _$ReportsTotal {
  @JsonSerializable(includeIfNull: false)
  const factory ReportsTotal({
    List<ReportsUnit>? units,
    @JsonKey(name: 'market_total') MarketTotal? marketTotal,
  }) = _ReportsTotal;

  factory ReportsTotal.fromJson(Map<String, dynamic> json) =>
      _$ReportsTotalFromJson(json);
}
