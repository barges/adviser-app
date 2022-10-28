import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState([
    @Default(0) int dashboardPageViewIndex,
    @Default(0) int dashboardDateFilterIndex,
  ]) = _DashboardState;
}
