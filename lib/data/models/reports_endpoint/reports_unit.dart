import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';

part 'reports_unit.freezed.dart';

part 'reports_unit.g.dart';

@freezed
class ReportsUnit with _$ReportsUnit {
  @JsonSerializable(includeIfNull: false)
  const factory ReportsUnit({
    String? group,
    SessionsTypes? type,
    int? number,
    double? amount,
    int? numberCancelled,
    double? amountCancelled,
  }) = _ReportsUnit;

  factory ReportsUnit.fromJson(Map<String, dynamic> json) =>
      _$ReportsUnitFromJson(json);
}
