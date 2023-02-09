// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_month.dart';

part 'reports_year.freezed.dart';

part 'reports_year.g.dart';

@freezed
class ReportsYear with _$ReportsYear {
  @JsonSerializable(includeIfNull: false)
  const factory ReportsYear({
    String? year,
    List<ReportsMonth>? months,
  }) = _ReportsYear;

  factory ReportsYear.fromJson(Map<String, dynamic> json) =>
      _$ReportsYearFromJson(json);
}
