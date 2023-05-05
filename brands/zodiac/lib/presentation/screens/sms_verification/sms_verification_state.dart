import 'package:freezed_annotation/freezed_annotation.dart';

part 'sms_verification_state.freezed.dart';

@freezed
class SMSVerificationState with _$SMSVerificationState {
  const factory SMSVerificationState({
    @Default(false) bool isError,
  }) = _SMSVerificationState;
}
