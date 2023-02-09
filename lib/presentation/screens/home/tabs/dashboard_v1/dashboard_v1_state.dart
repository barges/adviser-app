import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';

part 'dashboard_v1_state.freezed.dart';

@freezed
class DashboardV1State with _$DashboardV1State {
  const factory DashboardV1State([
    @Default(0) int dashboardPageViewIndex,
    @Default(0) int dashboardDateFilterIndex,
    @Default(0.0) double monthAmount,
    @Default('€') String currencySymbol,
    UserProfile? userProfile,
  ]) = _DashboardV1State;
}
