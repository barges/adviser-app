// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fortunica/data/models/enums/sessions_types.dart';

part 'reports_meta.freezed.dart';

part 'reports_meta.g.dart';

@freezed
class ReportsMeta with _$ReportsMeta {
  @JsonSerializable(includeIfNull: false)
  const factory ReportsMeta({
    DateTime? payoutDate,
    @JsonKey(name: 'expert') String? expertId,
    String? currency,
    @JsonKey(fromJson: _ratesFromJson) Map<SessionsTypes, double>? rates,
  }) = _ReportsMeta;

  factory ReportsMeta.fromJson(Map<String, dynamic> json) =>
      _$ReportsMetaFromJson(json);
}

Map<SessionsTypes, double>? _ratesFromJson(json) {
  final Map<SessionsTypes, double> ratingMap = {};

  (json as Map<String, dynamic>?)?.forEach((key, value) {
    if (SessionsTypes.actualSessionsTypes.contains(key)) {
      if (value is double) {
        ratingMap[SessionsTypes.typeFromString(key)] = value;
      }
    }
  });
  return ratingMap;
}
