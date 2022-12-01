import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default('') String errorMessage,
    @Default('') String emailErrorText,
    @Default(false) bool emailHasFocus,
    @Default('') String passwordErrorText,
    @Default(false) bool passwordHasFocus,
    @Default('') String confirmPasswordErrorText,
    @Default(false) bool confirmPasswordHasFocus,
    @Default(true) bool hiddenPassword,
    @Default(true) bool hiddenConfirmPassword,
    @Default(false) bool isButtonActive,
    String? resetToken,
  }) = _ForgotPasswordState;
}
