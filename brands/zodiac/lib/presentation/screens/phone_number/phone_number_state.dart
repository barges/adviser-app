import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/settings/phone.dart';

part 'phone_number_state.freezed.dart';

@freezed
class PhoneNumberState with _$PhoneNumberState {
  const factory PhoneNumberState({
    @Default(false) bool isPhoneNumberInputFocused,
    @Default(false) bool isSendCodeButtonEnabled,
    @Default(Phone()) phone,
    int? phoneNumberMaxLength,
    @Default(0) int verificationCodeAttempts,
  }) = _PhoneNumberState;
}
