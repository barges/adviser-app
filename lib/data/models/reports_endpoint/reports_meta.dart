import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';

part 'reports_meta.freezed.dart';
part 'reports_meta.g.dart';

@freezed
class ReportsMeta with _$ReportsMeta {

  @JsonSerializable(includeIfNull: false)
  const factory ReportsMeta({
    DateTime? payoutDate,
    @JsonKey(name: 'expert')
    String? expertId,
    String? currency,
    Map<SessionsTypes, double>? rates,
  }) = _ReportsMeta;

  factory ReportsMeta.fromJson(Map<String, dynamic> json) =>
      _$ReportsMetaFromJson(json);
}
