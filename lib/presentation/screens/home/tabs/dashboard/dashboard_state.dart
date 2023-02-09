import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState([
    @Default(0) int dashboardPageViewIndex,
    @Default(0) int dashboardDateFilterIndex,
    @Default(0.0) double monthAmount,
    UserProfile? userProfile,
  ]) = _DashboardState;
}
