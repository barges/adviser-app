import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/app_success/app_success.dart';
import '../../../data/models/enums/validation_error_type.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool emailHasFocus,
    @Default(false) bool passwordHasFocus,
    @Default(true) bool hiddenPassword,
    @Default(false) bool buttonIsActive,
    @Default(EmptySuccess()) AppSuccess appSuccess,
    @Default(ValidationErrorType.empty) ValidationErrorType emailErrorType,
    @Default(ValidationErrorType.empty) ValidationErrorType passwordErrorType,
  }) = _LoginState;
}
