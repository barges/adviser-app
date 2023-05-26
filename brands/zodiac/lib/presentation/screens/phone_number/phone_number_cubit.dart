import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:zodiac/data/models/settings/phone.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';
import 'package:zodiac/data/network/requests/phone_number_request.dart';
import 'package:zodiac/data/network/responses/phone_number_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';

import 'package:zodiac/presentation/screens/phone_number/phone_number_state.dart';
import 'package:zodiac/services/phone_country_codes.dart';

const pnoneNumberMaxLength = 15;
const verificationCodeAttemptsPer24HoursMax = 3;

class PhoneNumberCubit extends Cubit<PhoneNumberState> {
  Phone _phone;
  final ZodiacUserRepository _zodiacUserRepository;
  final ConnectivityService _connectivityService;
  final GlobalCachingManager _cacheManager;
  final FocusNode phoneNumberInputFocus = FocusNode();
  final TextEditingController phoneNumberInputController =
      TextEditingController();

  PhoneNumberCubit(
    this._phone,
    this._zodiacUserRepository,
    this._connectivityService,
    this._cacheManager,
  ) : super(const PhoneNumberState()) {
    _init();
  }

  _init() async {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setTextInputFocus(true));

    if (_phone.number != null) {
      phoneNumberInputController.text = _phone.number.toString();
    }
    if (_phone.code != null) {
      int? phoneNumberMaxLength =
          await compute(_getPhoneNumberMaxLength, _phone.code!);
      if (phoneNumberMaxLength != null) {
        _correctPhoneNumberDigitCount(phoneNumberMaxLength);
      }
      emit(state.copyWith(
        phone: _phone.copyWith(
            country: (_phone.country == null && _phone.code != null)
                ? _getCountryNameByCode(_phone.code!)
                : ''),
        isSendCodeButtonEnabled: isPhoneNumberValidLength,
        phoneNumberMaxLength: phoneNumberMaxLength,
      ));
    }

    phoneNumberInputController.addListener(() {
      _phone = _phone.copyWith(
          number: int.tryParse(phoneNumberInputController.text));
      final isValidLength = isPhoneNumberValidLength;
      emit(state.copyWith(
        isSendCodeButtonEnabled: isValidLength,
        phone: _phone,
      ));
    });
  }

  @override
  Future<void> close() async {
    phoneNumberInputFocus.dispose();
    phoneNumberInputController.dispose();
    return super.close();
  }

  Future<bool> sendCode() async {
    bool isSuccess = await _editPhoneNumber();
    if (!isSuccess) {
      emit(state.copyWith(
        isSendCodeButtonEnabled: false,
      ));
    }
    return isSuccess;
  }

  Future<bool> _editPhoneNumber() async {
    try {
      if (await _connectivityService.checkConnection()) {
        final PhoneNumberResponse response =
            await _zodiacUserRepository.editPhoneNumber(PhoneNumberRequest(
          phoneCode: _phone.code!,
          phoneNumber: _phone.number,
          captchaResponse: 'captcha_response_success',
        ));
        return response.status == true && response.needVerification == true;
      }
    } catch (e) {
      logger.d(e);
    }

    return false;
  }

  Future<void> setPhoneCountryCode(PhoneCountryCode phoneCountryCode) async {
    _phone = _phone.copyWith(
      code: phoneCountryCode.toCodeInt(),
      country: phoneCountryCode.name,
    );

    int? phoneNumberMaxLength = _phone.code != null
        ? await compute(_getPhoneNumberMaxLength, _phone.code!)
        : null;
    if (phoneNumberMaxLength != null) {
      _correctPhoneNumberDigitCount(phoneNumberMaxLength);
    }
    emit(state.copyWith(
      phone: _phone,
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
    final phoneNumberParsed = PhoneNumber.parse(_phone.toString());
    return phoneNumberParsed.isValidLength();
  }

  Phone get phone => _phone;
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
