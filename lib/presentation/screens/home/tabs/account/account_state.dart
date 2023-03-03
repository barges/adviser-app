import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';

part 'account_state.freezed.dart';

@freezed
class AccountState with _$AccountState {
  const factory AccountState({
    @Default(true) bool isAvailable,
    @Default(false) bool enableNotifications,
    @Default(false) bool commentButtonIsActive,
    @Default(false) bool commentHasFocus,
    @Default(0) int secondsForTimer,
    UserProfile? userProfile,
    @Default(false) bool isTimeout,
  }) = _AccountState;
}
