import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:zodiac/data/models/app_error/app_error.dart';
import 'package:zodiac/data/models/app_error/ui_error_type.dart';
import 'package:zodiac/data/models/enums/recaptcha_custom_action.dart';
import 'package:zodiac/data/models/settings/phone.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';
import 'package:zodiac/data/network/requests/phone_number_request.dart';
import 'package:zodiac/data/network/responses/phone_number_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';

import 'package:zodiac/presentation/screens/phone_number/phone_number_state.dart';
import 'package:zodiac/services/recaptcha/recaptcha_service.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

const countryPhoneCodesJsonPath =
    'assets/zodiac/files/country_phone_codes.json';
const pnoneNumberMaxLength = 15;
const verificationCodeAttemptsPer24HoursMax = 3;

@injectable
class PhoneNumberCubit extends Cubit<PhoneNumberState> {
  Phone _phone;
  final String? _siteKey;
  final MainCubit _globalMainCubit;
  final ZodiacMainCubit _zodiacMainCubit;
  final ZodiacUserRepository _zodiacUserRepository;
  final ConnectivityService _connectivityService;

  final List<PhoneCountryCode> _phoneCountryCodes = [];

  Phone? _phoneVerified;
  StreamSubscription<bool>? _appLifecycleSubscription;
  bool _recaptchaServiceIsInitialized = false;

  PhoneNumberCubit(
    @factoryParam this._siteKey,
    @factoryParam this._phone,
    this._globalMainCubit,
    this._zodiacMainCubit,
    this._zodiacUserRepository,
    this._connectivityService,
  ) : super(const PhoneNumberState()) {
    _init();
  }

  @override
  Future<void> close() async {
    _appLifecycleSubscription?.cancel();
    return super.close();
  }

  _init() async {
    await _initRecaptchaService();
    await _loadCountryPhoneCodesJson();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => setTextInputFocus(true));

    if (_phone.isVerified == true) {
      _phoneVerified = _phone;
    }

    if (_phone.code != null) {
      int phoneNumberMaxLength = await _getPhoneNumberMaxLength();
      emit(state.copyWith(
        phone: _phone.copyWith(
            country: (_phone.country == null && _phone.code != null)
                ? _getCountryNameByCode(_phone.code!)
                : ''),
        isSendCodeButtonEnabled: _isSendCodeButtonEnabled(),
        phoneNumberMaxLength: phoneNumberMaxLength,
      ));
    }

    if (Platform.isAndroid) {
      _appLifecycleSubscription =
          _globalMainCubit.changeAppLifecycleStream.listen(
        (value) {
          if (value) {
            if (state.isPhoneCodeSearchVisible) {
              emit(state.copyWith(isPhoneCodeSearchFocused: true));
            } else {
              setTextInputFocus(true);
            }
          } else {
            if (state.isPhoneCodeSearchVisible) {
              emit(state.copyWith(isPhoneCodeSearchFocused: false));
            } else {
              setTextInputFocus(false);
            }
          }
        },
      );
    }
  }

  Future<void> _initRecaptchaService() async {
    if (_siteKey != null) {
      try {
        await RecaptchaService.initRecaptcha(_siteKey!);
        _recaptchaServiceIsInitialized = true;
      } catch (e) {
        _zodiacMainCubit.updateErrorMessage(
          UIError(
            uiErrorType: UIErrorType.phoneVerificationUnavailable,
          ),
        );
        logger.d(e);
      }
    } else {
      _zodiacMainCubit.updateErrorMessage(
        UIError(
          uiErrorType: UIErrorType.phoneVerificationUnavailable,
        ),
      );
    }
  }

  Future<void> _loadCountryPhoneCodesJson() async {
    final String response =
        await rootBundle.loadString(countryPhoneCodesJsonPath);
    final List<dynamic> jsonData = await jsonDecode(response);
    for (var json in jsonData) {
      _phoneCountryCodes.add(PhoneCountryCode.fromJson(json));
    }
  }

  List<PhoneCountryCode> _searchPhoneCountryCodes(String text) {
    String searchText = text.trim().toLowerCase();
    return _phoneCountryCodes.where((item) {
      if (item.name != null &&
          item.name!.toLowerCase().startsWith(searchText)) {
        return true;
      }
      if (item.code != null &&
          item.code!.startsWith(
              searchText.toLowerCase(), searchText.startsWith('+') ? 0 : 1)) {
        return true;
      }
      return false;
    }).toList();
  }

  String? _getCountryNameByCode(int code) {
    return _phoneCountryCodes
        .firstWhereOrNull((item) => item.toCodeInt() == code)
        ?.name;
  }

  void updatePhoneCodeSearchVisibility(bool isVisible) {
    if (isVisible) {
      emit(
        state.copyWith(
          searchedPhoneCountryCodes: _phoneCountryCodes,
        ),
      );
    } else {
      setTextInputFocus(true);
    }
    emit(
      state.copyWith(
        isPhoneCodeSearchVisible: isVisible,
      ),
    );
  }

  void searchPhoneCountryCodes(String text) {
    final List<PhoneCountryCode> searchedPhoneCountryCodes =
        _searchPhoneCountryCodes(text);
    emit(
      state.copyWith(
        searchedPhoneCountryCodes: searchedPhoneCountryCodes,
      ),
    );
  }

  Future<bool> sendCode() async {
    final response = await _editPhoneNumber();
    bool isSuccess = response != null
        ? response.status == true && response.needVerification == true
        : false;
    if (!isSuccess) {
      emit(state.copyWith(
        isSendCodeButtonEnabled: response?.errorCode == 3 ? true : isSuccess,
      ));
    }
    return isSuccess;
  }

  Future<PhoneNumberResponse?> _editPhoneNumber() async {
    try {
      if (await _connectivityService.checkConnection()) {
        final token = await RecaptchaService.execute(
            RecaptchaCustomAction.phoneVerifyNumber);

        final PhoneNumberResponse response =
            await _zodiacUserRepository.editPhoneNumber(PhoneNumberRequest(
          phoneCode: _phone.code!,
          phoneNumber: _phone.number,
          captchaResponse: token,
        ));
        return response;
      }
    } catch (e) {
      logger.d(e);
      rethrow;
    }
    return null;
  }

  Future<void> setPhoneCountryCode(PhoneCountryCode phoneCountryCode) async {
    _phone = _phone.copyWith(
      code: phoneCountryCode.toCodeInt(),
      country: phoneCountryCode.name,
    );

    int phoneNumberMaxLength = await _getPhoneNumberMaxLength();
    emit(state.copyWith(
      phone: _phone,
      isSendCodeButtonEnabled: _isSendCodeButtonEnabled(),
      phoneNumberMaxLength: phoneNumberMaxLength,
    ));
  }

  void setPhoneNumber(String number) {
    _phone = _phone.copyWith(number: int.tryParse(number));
    emit(state.copyWith(
      isSendCodeButtonEnabled: _isSendCodeButtonEnabled(),
      phone: _phone,
    ));
  }

  void setTextInputFocus(bool value) {
    emit(state.copyWith(isPhoneNumberInputFocused: value));
  }

  void clearErrorMessage() {
    _zodiacMainCubit.clearErrorMessage();
  }

  Future<int> _getPhoneNumberMaxLength() async {
    int maxLength = _phone.code != null
        ? await compute(_getPhoneNumberMaxLengthForCode, _phone.code!)
        : pnoneNumberMaxLength;
    return maxLength;
  }

  bool _isSendCodeButtonEnabled() {
    return _isPhoneNumberValidLength() &&
        !_phoneIsVerified() &&
        _recaptchaServiceIsInitialized;
  }

  bool _phoneIsVerified() {
    return _phoneVerified?.code == _phone.code &&
        _phoneVerified?.number == _phone.number;
  }

  bool _isPhoneNumberValidLength() {
    final phoneNumberParsed = PhoneNumber.parse(_phone.toString());
    return phoneNumberParsed.isValidLength();
  }

  Phone get phone => _phone;
}

int _getPhoneNumberMaxLengthForCode(int code) {
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
