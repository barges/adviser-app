import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/configuration.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(Brand.fortunica) Brand selectedBrand,
    @Default('') String emailErrorText,
    @Default(false) bool emailHasFocus,
    @Default('') String passwordErrorText,
    @Default(false) bool passwordHasFocus,
    @Default(true) bool hiddenPassword,
    @Default(false) bool buttonIsActive,
    @Default('') String successMessage,
  }) = _LoginState;
}
