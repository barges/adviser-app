import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_statistics.dart';

part 'reports_month.freezed.dart';
part 'reports_month.g.dart';

@freezed
class ReportsMonth with _$ReportsMonth {

  @JsonSerializable(includeIfNull: false)
  const factory ReportsMonth({
    String? month,
    String? name,
    String? startDate,
    String? endDate,
    bool? current,
    ReportsStatistics? statistics,
  }) = _ReportsMonth;

  factory ReportsMonth.fromJson(Map<String, dynamic> json) =>
      _$ReportsMonthFromJson(json);
}