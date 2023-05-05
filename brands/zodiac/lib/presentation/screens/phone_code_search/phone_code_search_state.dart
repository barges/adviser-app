import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';

part 'phone_code_search_state.freezed.dart';

@freezed
class PhoneCodeSearchState with _$PhoneCodeSearchState {
  const factory PhoneCodeSearchState({
    @Default([]) List<PhoneCountryCode> searchedPhoneCountryCodes,
  }) = _PhoneCodeSearchState;
}
