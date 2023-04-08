import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/data/models/user_info/locale_descriptions.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/locale_descriptions_request.dart';
import 'package:zodiac/data/network/responses/locale_descriptions_response.dart';
import 'package:zodiac/data/network/responses/main_specialization_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

const int _textFieldsCount = 4;

const int nickNameIndex = 0;
const int aboutIndex = 1;
const int experienceIndex = 2;
const int helloMessageIndex = 3;

class EditProfileCubit extends Cubit<EditProfileState> {
  final ZodiacMainCubit _mainCubit;
  final ZodiacCachingManager _cachingManager;
  final ZodiacUserRepository _userRepository;

  late final StreamSubscription userInfoSubscription;
  late List<GlobalKey> localesGlobalKeys;

  HtmlEditorController htmlController = HtmlEditorController();

  final Map<String, List<TextEditingController>> textControllersMap = {};
  final Map<String, List<FocusNode>> focusNodesMap = {};
  final Map<String, List<ValueNotifier>> hasFocusNotifiersMap = {};
  final Map<String, List<ValidationErrorType>> errorTextsMap = {};

  final Map<String, List<String>> _oldTextsMap = {};

  final GlobalKey profileAvatarKey = GlobalKey();

  DetailedUserInfo? detailedUserInfo;
  final List<String> _newLocales = [];

  bool _wasFocusRequest = false;

  EditProfileCubit(
    this._mainCubit,
    this._cachingManager,
    this._userRepository,
  ) : super(const EditProfileState()) {
    final DetailedUserInfo? userInfoFromCache =
        _cachingManager.getDetailedUserInfo();

    final List<String> locales = userInfoFromCache?.locales ?? [];
    localesGlobalKeys = locales.map((e) => GlobalKey()).toList();

    final List<CategoryInfo>? advisorCategories = userInfoFromCache?.category;
    List<CategoryInfo>? categories = [];
    if (advisorCategories != null) {
      categories = CategoryInfo.normalizeList(advisorCategories);
    }

    emit(state.copyWith(
      detailedUserInfo: userInfoFromCache,
      advisorLocales: locales,
      advisorCategories: categories,
    ));

    userInfoSubscription = _cachingManager.listenDetailedUserInfo((value) {
      detailedUserInfo ??= value;
      emit(state.copyWith(
        detailedUserInfo: value,
      ));
    });
    getMainSpeciality();
    _setUpLocalesDescriptions();
  }

  @override
  Future<void> close() {
    for (var entry in textControllersMap.entries) {
      for (var element in entry.value) {
        element.dispose();
      }
    }
    for (var entry in focusNodesMap.entries) {
      for (var element in entry.value) {
        element.dispose();
      }
    }
    for (var entry in hasFocusNotifiersMap.entries) {
      for (var element in entry.value) {
        element.dispose();
      }
    }
    userInfoSubscription.cancel();
    return super.close();
  }

  Future<void> getMainSpeciality() async {
    final MainSpecializationResponse response =
        await _userRepository.getMainSpeciality(AuthorizedRequest());
    final CategoryInfo? mainCategory = response.result;
    if (mainCategory != null) {
      updateMainCategory([mainCategory]);
    }
  }

  Future<void> refreshUserProfile() async {
    _mainCubit.updateAccount();
  }

  void setAvatar(File avatar) {
    emit(state.copyWith(avatar: avatar));
  }

  String localeNativeName(String code) {
    List<LocaleModel>? locales = _cachingManager.getAllLocales();

    return locales?.firstWhere((element) => element.code == code).nameNative ??
        'English';
  }

  void changeLocaleIndex(int newIndex) {
    emit(state.copyWith(currentLocaleIndex: newIndex));
    Utils.animateToWidget(localesGlobalKeys[newIndex]);
  }

  Future<void> _setUpLocalesDescriptions() async {
    final List<String> locales = state.advisorLocales;
    for (String locale in locales) {
      final LocaleDescriptionsResponse response =
          await _userRepository.getLocaleDescriptions(
        LocaleDescriptionsRequest(locale: locale),
      );
      final LocaleDescriptions? descriptions = response.result;
      if (response.status == true && descriptions != null) {
        _oldTextsMap[locale] = [
          descriptions.nickname ?? '',
          descriptions.about ?? '',
          descriptions.experience ?? '',
          descriptions.helloMessage ?? '',
        ];

        final List<String>? texts = _oldTextsMap[locale];

        if (texts != null) {
          textControllersMap[locale] =
              texts.map((e) => TextEditingController()..text = e).toList();
          focusNodesMap[locale] = texts.map((e) => FocusNode()).toList();
          hasFocusNotifiersMap[locale] =
              texts.map((e) => ValueNotifier(false)).toList();
          errorTextsMap[locale] =
              texts.map((e) => ValidationErrorType.empty).toList();
        }
      }
    }
    if (_oldTextsMap.isNotEmpty) {
      emit(state.copyWith(updateTextsFlag: !state.updateTextsFlag));
    }

    _addListenersToFocusNodes();
    _addListenersToTextControllers();
  }

  void _addListenersToFocusNodes() {
    for (var entry in focusNodesMap.entries) {
      for (int i = 0; i < entry.value.length; i++) {
        entry.value[i].addListener(() {
          hasFocusNotifiersMap[entry.key]?[i].value = entry.value[i].hasFocus;
        });
      }
    }
  }

  void _addListenersToTextControllers() {
    final List<String> locales = state.advisorLocales;
    for (String localeCode in locales) {
      final List<TextEditingController>? controllersByLocale =
          textControllersMap[localeCode];
      if (controllersByLocale != null) {
        for (int i = 0; i < controllersByLocale.length; i++) {
          controllersByLocale[i].addListener(() {
            errorTextsMap[localeCode]?[i] = ValidationErrorType.empty;
            emit(state.copyWith(updateTextsFlag: !state.updateTextsFlag));
          });
        }
      }
    }
  }

  Future<void> goToSelectAllCategories(BuildContext context) async {
    context.push(
        route: ZodiacSpecialitiesList(
            oldSelectedCategories: state.advisorCategories,
            returnCallback: (categories) {
              emit(state.copyWith(advisorCategories: categories));
            }));
  }

  Future<void> goToSelectMainCategory(BuildContext context) async {
    context.push(
      route: ZodiacSpecialitiesList(
          isMultiselect: false,
          oldSelectedCategories: state.advisorMainCategory,
          returnCallback: (categories) {
            logger.d(categories.first.name);
            updateMainCategory(categories);
          }),
    );
  }

  Future<void> goToAddNewLocale(BuildContext context) async {
    context.push(
      route: ZodiacLocalesList(
        title: 'Language',
        unnecessaryLocalesCodes: state.advisorLocales,
        returnCallback: (locale) {
          addLocaleLocally(locale);
        },
      ),
    );
  }

  void addLocaleLocally(String localeCode) {
    final List<String> locales = List.from(state.advisorLocales);
    locales.add(localeCode);
    _newLocales.add(localeCode);
    _setNewLocaleProperties(localeCode);

    emit(state.copyWith(advisorLocales: locales));

    final codeIndex = locales.indexOf(localeCode);
    if (codeIndex != -1) {
      changeLocaleIndex(codeIndex);
    }
  }

  void _setNewLocaleProperties(String localeCode) {
    textControllersMap[localeCode] = List<TextEditingController>.generate(
      _textFieldsCount,
      (index) => TextEditingController(),
    );
    focusNodesMap[localeCode] = List<FocusNode>.generate(
      _textFieldsCount,
      (index) => FocusNode(),
    );
    hasFocusNotifiersMap[localeCode] = List<ValueNotifier>.generate(
      _textFieldsCount,
      (index) => ValueNotifier(false),
    );
    errorTextsMap[localeCode] = List<ValidationErrorType>.generate(
      _textFieldsCount,
      (index) => ValidationErrorType.empty,
    );

    final List<FocusNode>? nodes = focusNodesMap[localeCode];
    if (nodes != null) {
      for (int i = 0; i < nodes.length; i++) {
        nodes[i].addListener(() {
          hasFocusNotifiersMap[localeCode]?[i].value = nodes[i].hasFocus;
        });
      }
    }

    final List<TextEditingController>? controllersByLocale =
        textControllersMap[localeCode];
    if (controllersByLocale != null) {
      for (int i = 0; i < controllersByLocale.length; i++) {
        controllersByLocale[i].addListener(() {
          errorTextsMap[localeCode]?[i] = ValidationErrorType.empty;
          emit(state.copyWith(updateTextsFlag: !state.updateTextsFlag));
        });
      }
    }
    localesGlobalKeys.add(GlobalKey());
  }

  Future<void> saveInfo() async {
    checkTextFields();

    // if (state.avatar != null) {
    //   final BaseResponse response = await _userRepository.uploadAvatar(
    //     request: AuthorizedRequest(),
    //     brandId: Brands.zodiac.id,
    //     avatar: state.avatar!,
    //   );
    // }
  }

  bool checkTextFields() {
    bool isValid = true;
    int? firstLanguageWithErrorIndex;
    final List<String> locales = state.advisorLocales;
    for (String localeCode in locales) {
      final List<TextEditingController>? controllersByLocale =
          textControllersMap[localeCode];
      if (controllersByLocale != null) {
        for (int i = 0; i < controllersByLocale.length; i++) {
          if (i == nickNameIndex) {
            if (!_checkNickName(localeCode)) {
              firstLanguageWithErrorIndex ??= locales.indexOf(localeCode);
              _wasFocusRequest = true;
              isValid = false;
            }
          } else {
            if (!_checkTextField(localeCode, i)) {
              firstLanguageWithErrorIndex ??= locales.indexOf(localeCode);
              _wasFocusRequest = true;
              isValid = false;
            }
          }
          if (localeCode == locales.lastOrNull &&
              i == controllersByLocale.length - 1) {
            _wasFocusRequest = false;
          }
        }
      }
    }
    emit(state.copyWith(updateTextsFlag: !state.updateTextsFlag));
    if (firstLanguageWithErrorIndex != null) {
      changeLocaleIndex(firstLanguageWithErrorIndex);
    }
    return isValid;
  }

  bool _checkNickName(String localeCode) {
    bool isValid = true;
    final String nickName =
        textControllersMap[localeCode]?[nickNameIndex].text.trim() ?? '';
    final bool isShort = nickName.length < 3;
    final bool isLong = nickName.length > 250;
    if (isShort || isLong) {
      isValid = false;

      ///TODO: add 250 chars error
      errorTextsMap[localeCode]?[nickNameIndex] = isShort
          ? ValidationErrorType.pleaseEnterAtLeast3Characters
          : ValidationErrorType.pleaseEnterAtLeast3Characters;

      if (!_wasFocusRequest) {
        focusNodesMap[localeCode]?[nickNameIndex].requestFocus();
      }
    }
    return isValid;
  }

  bool _checkTextField(String localeCode, int index) {
    bool isValid = true;
    final String text =
        textControllersMap[localeCode]?[index].text.trim() ?? '';
    final bool isShort = text.isEmpty;
    final bool isLong = text.length > 65000;
    if (isShort || isLong) {
      isValid = false;

      ///TODO: add 65000 chars error
      errorTextsMap[localeCode]?[index] = isShort
          ? ValidationErrorType.requiredField
          : ValidationErrorType.pleaseEnterAtLeast3Characters;

      if (!_wasFocusRequest) {
        focusNodesMap[localeCode]?[index].requestFocus();
      }
    }
    return isValid;
  }

  void updateMainCategory(List<CategoryInfo> mainCategory) {
    emit(state.copyWith(advisorMainCategory: mainCategory));
  }
}
