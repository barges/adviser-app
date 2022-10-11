import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_meta.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_year.dart';

part 'reports_response.g.dart';

@JsonSerializable(includeIfNull: false)
class ReportsResponse {
  final ReportsMeta? meta;
  final List<ReportsYear>? dateRange;

  ReportsResponse(this.meta, this.dateRange);

  factory ReportsResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReportsResponseToJson(this);
}
