import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:zodiac/data/models/enums/recaptcha_custom_action.dart';
import 'package:zodiac/data/models/settings/phone.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';

import 'package:zodiac/presentation/screens/phone_number/phone_number_state.dart';
import 'package:zodiac/services/phone_country_codes.dart';
import 'package:zodiac/services/recaptcha.dart';

const pnoneNumberMaxLength = 15;

class PhoneNumberCubit extends Cubit<PhoneNumberState> {
  Phone phoneNumber;
  final FocusNode phoneNumberInputFocus = FocusNode();
  final TextEditingController phoneNumberInputController =
      TextEditingController();
  //final RecaptchaApi recaptchaApi = RecaptchaApi();
  //static bool _isRecaptchaItialized = false;

  PhoneNumberCubit(this.phoneNumber) : super(const PhoneNumberState()) {
    _init();
  }

  _init() async {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setTextInputFocus(true));

    if (phoneNumber.number != null) {
      phoneNumberInputController.text = phoneNumber.number.toString();
    }
    int? phoneNumberMaxLength;
    if (phoneNumber.code != null) {
      phoneNumberMaxLength =
          await compute(_getPhoneNumberMaxLength, phoneNumber.code!);
      if (phoneNumberMaxLength != null) {
        _correctPhoneNumberDigitCount(phoneNumberMaxLength);
      }
    }

    final recaptchaisInitialized = await Recaptcha.isInitialized();

    emit(state.copyWith(
      phone: phoneNumber.copyWith(
          country: (phoneNumber.country == null && phoneNumber.code != null)
              ? _getCountryNameByCode(phoneNumber.code!)
              : ''),
      isSendCodeButtonEnabled:
          isPhoneNumberValidLength && recaptchaisInitialized,
      phoneNumberMaxLength: phoneNumberMaxLength,
    ));

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

  Future<void> setPhoneCountryCode(PhoneCountryCode phoneCountryCode) async {
    phoneNumber = phoneNumber.copyWith(
      code: phoneCountryCode.toCodeInt(),
      country: phoneCountryCode.name,
    );

    int? phoneNumberMaxLength = phoneNumber.code != null
        ? await compute(_getPhoneNumberMaxLength, phoneNumber.code!)
        : null;
    if (phoneNumberMaxLength != null) {
      _correctPhoneNumberDigitCount(phoneNumberMaxLength);
    }
    emit(state.copyWith(
      phone: phoneNumber,
      isSendCodeButtonEnabled: isPhoneNumberValidLength,
      phoneNumberMaxLength: phoneNumberMaxLength,
    ));
  }

  void setTextInputFocus(bool value) {
    emit(state.copyWith(isPhoneNumberInputFocused: value));
    if (value) {
      phoneNumberInputFocus.requestFocus();
    }
  }

  Future<void> sendCode() async {
    //final result = await recaptchaApi.execute('phone_verify_number');
    // print('!!!!! result: $result');
  }

  void _correctPhoneNumberDigitCount(int maxLength) {
    if (phoneNumberInputController.text.length > maxLength) {
      phoneNumberInputController.text =
          phoneNumberInputController.text.substring(0, maxLength);
      phoneNumberInputController.selection = TextSelection.collapsed(
          offset: phoneNumberInputController.text.length);
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

int _getPhoneNumberMaxLength(int code) {
  final List<String> splittedNumber = '111111111111111'.split('');
  String testNumber = '';
  bool isValidLengthPrev = false;
  for (var item in splittedNumber) {
    testNumber += item;
    final isValidLength =
        PhoneNumber.parse('+$code$testNumber').isValidLength();
    if (isValidLengthPrev && !isValidLength) {
      return testNumber.length - 1;
    }
    isValidLengthPrev = isValidLength;
  }

  return pnoneNumberMaxLength;
}
