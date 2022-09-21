
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_state.freezed.dart';

@freezed
class AccountState with _$AccountState {
  const factory AccountState([
    @Default(true) bool isAvailable,
    @Default(false) bool enableNotifications,
  ]) = _AccountState;
}
