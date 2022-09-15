import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default('') String errorMessage,
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default(true) bool hiddenPassword,
    @Default(true) bool hiddenConfirmPassword,
    @Default(false) bool isLoading,
  }) = _ForgotPasswordState;
}
