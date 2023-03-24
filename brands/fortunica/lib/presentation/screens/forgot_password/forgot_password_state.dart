import 'package:fortunica/data/models/enums/validation_error_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default('') String errorMessage,
    @Default(false) bool emailHasFocus,
    @Default(false) bool passwordHasFocus,
    @Default(false) bool confirmPasswordHasFocus,
    @Default(true) bool hiddenPassword,
    @Default(true) bool hiddenConfirmPassword,
    @Default(false) bool isButtonActive,
    @Default(false) bool isResetSuccess,
    @Default(ValidationErrorType.empty) ValidationErrorType emailErrorType,
    @Default(ValidationErrorType.empty) ValidationErrorType passwordErrorType,
    @Default(ValidationErrorType.empty)
        ValidationErrorType confirmPasswordErrorType,
    String? resetToken,
  }) = _ForgotPasswordState;
}
