import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';

part 'forgot_password_state.freezed.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default(ValidationErrorType.empty) ValidationErrorType emailErrorType,
  }) = _ForgotPasswordState;
}
