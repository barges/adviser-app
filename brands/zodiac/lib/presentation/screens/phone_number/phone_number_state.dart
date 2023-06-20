import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/settings/phone.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';
import 'package:zodiac/presentation/screens/phone_number/phone_number_cubit.dart';

part 'phone_number_state.freezed.dart';

@freezed
class PhoneNumberState with _$PhoneNumberState {
  const factory PhoneNumberState({
    @Default(false) bool isPhoneNumberInputFocused,
    @Default(false) bool isPhoneCodeSearchFocused,
    @Default(false) bool isSendCodeButtonEnabled,
    @Default(false) bool isPhoneCodeSearchVisible,
    @Default(Phone()) phone,
    @Default([]) List<PhoneCountryCode> searchedPhoneCountryCodes,
    @Default(pnoneNumberMaxLength) int phoneNumberMaxLength,
    int? verificationCodeAttempts,
  }) = _PhoneNumberState;
}
