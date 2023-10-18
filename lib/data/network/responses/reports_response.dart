// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/reports_endpoint/reports_meta.dart';
import '../../models/reports_endpoint/reports_year.dart';

part 'reports_response.g.dart';
part 'reports_response.freezed.dart';

@freezed
class ReportsResponse with _$ReportsResponse {
  @JsonSerializable(includeIfNull: false)
  const factory ReportsResponse({
    ReportsMeta? meta,
    List<ReportsYear>? dateRange,
  }) = _ReportsResponse;

  factory ReportsResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportsResponseFromJson(json);
}
