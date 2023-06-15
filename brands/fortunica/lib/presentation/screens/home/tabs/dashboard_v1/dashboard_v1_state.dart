import 'package:fortunica/data/models/reports_endpoint/reports_month.dart';
import 'package:fortunica/data/models/reports_endpoint/reports_statistics.dart';
import 'package:fortunica/data/models/user_info/user_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_v1_state.freezed.dart';

@freezed
class DashboardV1State with _$DashboardV1State {
  const factory DashboardV1State([
    @Default(0) int dashboardPageViewIndex,
    @Default(0) int dashboardDateFilterIndex,
    @Default(0.0) double monthAmount,
    @Default('€') String currencySymbol,
    UserProfile? userProfile,
    @Default([]) List<ReportsMonth> months,
    @Default(ReportsStatistics()) ReportsStatistics? reportsStatistics,
    @Default(0) int currentMonthIndex,
  ]) = _DashboardV1State;
}
