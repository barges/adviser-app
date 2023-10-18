// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'reports_market.dart';
import 'reports_meta.dart';
import 'reports_total.dart';

part 'reports_statistics.freezed.dart';

part 'reports_statistics.g.dart';

@freezed
class ReportsStatistics with _$ReportsStatistics {
  @JsonSerializable(includeIfNull: false)
  const factory ReportsStatistics({
    ReportsMeta? meta,
    List<ReportsMarket>? markets,
    ReportsTotal? total,
  }) = _ReportsStatistics;

  factory ReportsStatistics.fromJson(Map<String, dynamic> json) =>
      _$ReportsStatisticsFromJson(json);
}
