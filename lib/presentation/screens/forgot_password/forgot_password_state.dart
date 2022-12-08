import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/configuration.dart';

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
    @Default(false) bool isResetSuccess,
    @Default(Brand.fortunica) Brand selectedBrand,
    String? resetToken,
  }) = _ForgotPasswordState;
}
