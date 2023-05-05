import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';

import 'package:zodiac/presentation/screens/phone_code_search/phone_code_search_state.dart';
import 'package:zodiac/services/phone_country_codes.dart';

class PhoneCodeSearchCubit extends Cubit<PhoneCodeSearchState> {
  PhoneCodeSearchCubit() : super(const PhoneCodeSearchState()) {
    searchPhoneCountryCodes('');
  }

  void searchPhoneCountryCodes(String text) {
    final List<PhoneCountryCode> searchedPhoneCountryCodes =
        PhoneCountryCodes.searchPhoneCountryCodes(text);
    emit(
      state.copyWith(
        searchedPhoneCountryCodes: searchedPhoneCountryCodes,
      ),
    );
  }
}
