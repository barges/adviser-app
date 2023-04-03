import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default('\$') String currencySymbol,
    UserDetails? userPersonalInfo,
    UserBalance? userBalance,
  }) = _DashboardState;
}
