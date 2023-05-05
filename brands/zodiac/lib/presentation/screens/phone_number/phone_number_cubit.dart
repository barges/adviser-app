import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:zodiac/data/models/settings/phone.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';

import 'package:zodiac/presentation/screens/phone_number/phone_number_state.dart';
import 'package:zodiac/services/phone_country_codes.dart';

class PhoneNumberCubit extends Cubit<PhoneNumberState> {
  Phone phoneNumber;
  final FocusNode phoneNumberInputFocus = FocusNode();
  final TextEditingController phoneNumberInputController =
      TextEditingController();

  PhoneNumberCubit(this.phoneNumber) : super(const PhoneNumberState()) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setTextInputFocus(true));

    if (phoneNumber.number != null) {
      phoneNumberInputController.text = phoneNumber.number.toString();
    }
    if (phoneNumber.code != null) {
      emit(state.copyWith(
        phone: phoneNumber.copyWith(
            country: (phoneNumber.country == null && phoneNumber.code != null)
                ? _getCountryNameByCode(phoneNumber.code!)
                : ''),
      ));
    }

    phoneNumberInputController.addListener(() {
      phoneNumber = phoneNumber.copyWith(
          number: int.tryParse(phoneNumberInputController.text));
      final isValidLength = isPhoneNumberValidLength;
      emit(state.copyWith(
        isSendCodeButtonEnabled: isValidLength,
        phone: isValidLength ? phoneNumber : state.phone,
      ));
    });
  }

  @override
  Future<void> close() async {
    phoneNumberInputFocus.dispose();
    phoneNumberInputController.dispose();
    return super.close();
  }

  void setPhoneCountryCode(PhoneCountryCode phoneCountryCode) {
    phoneNumber = phoneNumber.copyWith(
      code: phoneCountryCode.toCodeInt(),
      country: phoneCountryCode.name,
    );
    emit(state.copyWith(
      phone: phoneNumber,
      isSendCodeButtonEnabled: isPhoneNumberValidLength,
    ));
  }

  void setTextInputFocus(bool value) {
    emit(state.copyWith(isPhoneNumberInputFocused: value));
    if (value) {
      phoneNumberInputFocus.requestFocus();
    }
  }

  String? _getCountryNameByCode(int code) {
    return PhoneCountryCodes.getCountryNameByCode(code);
  }

  bool get isPhoneNumberValidLength {
    final phoneNumberParsed = PhoneNumber.parse(phoneNumber.toString());
    return phoneNumberParsed.isValidLength();
  }
}
