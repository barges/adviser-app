// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import '../../../../extensions.dart';

import 'reports_statistics.dart';

part 'reports_month.freezed.dart';

part 'reports_month.g.dart';

@freezed
class ReportsMonth with _$ReportsMonth {
  const ReportsMonth._();

  @JsonSerializable(includeIfNull: false)
  const factory ReportsMonth({
    @JsonKey(name: 'month') String? monthName,
    @JsonKey(name: 'name') String? monthDate,
    String? startDate,
    String? endDate,
    bool? current,
    ReportsStatistics? statistics,
  }) = _ReportsMonth;

  factory ReportsMonth.fromJson(Map<String, dynamic> json) =>
      _$ReportsMonthFromJson(json);

  String get nameFromDate {
    final List<String>? yearMonth = monthDate?.split('-');
    if ((yearMonth?.length == 2) == true) {
      return DateFormat.MMMM()
              .format(
                DateTime(
                  int.parse(yearMonth!.first),
                  int.parse(yearMonth.last),
                ),
              )
              .capitalize ??
          'Month Name';
    }
    return 'Month Name';
  }
}
