import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/enums/validation_error_type.dart';

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
    @Default(Brand.fortunica) Brand selectedBrand,
    @Default(ValidationErrorType.empty) ValidationErrorType emailErrorType,
    @Default(ValidationErrorType.empty) ValidationErrorType passwordErrorType,
    @Default(ValidationErrorType.empty)
        ValidationErrorType confirmPasswordErrorType,
    String? resetToken,
  }) = _ForgotPasswordState;
}
