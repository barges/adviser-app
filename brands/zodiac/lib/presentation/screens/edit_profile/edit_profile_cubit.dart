import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/brands.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/data/models/user_info/brand_model.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/data/models/user_info/locale_descriptions.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/data/network/requests/add_remove_locale_request.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/change_advisor_specializations_request.dart';
import 'package:zodiac/data/network/requests/change_main_specialization_request.dart';
import 'package:zodiac/data/network/requests/locale_descriptions_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/brand_locales_response.dart';
import 'package:zodiac/data/network/responses/locale_descriptions_response.dart';
import 'package:zodiac/data/network/responses/main_specialization_response.dart';
import 'package:zodiac/domain/repositories/zodiac_edit_profile_repository.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_state.dart';

const int _textFieldsCount = 4;

const int nickNameIndex = 0;
const int aboutIndex = 1;
const int experienceIndex = 2;
const int helloMessageIndex = 3;

class EditProfileCubit extends Cubit<EditProfileState> {
  final ZodiacCachingManager _cachingManager;
  final ZodiacUserRepository _userRepository;
  final ConnectivityService _connectivityService;
  final ZodiacEditProfileRepository _editProfileRepository;

  late final StreamSubscription<bool> _internetConnectionSubscription;
  late List<GlobalKey> localesGlobalKeys;

  final Map<String, List<TextEditingController>> textControllersMap = {};
  final Map<String, List<FocusNode>> focusNodesMap = {};
  final Map<String, List<ValueNotifier>> hasFocusNotifiersMap = {};
  final Map<String, List<ValidationErrorType>> errorTextsMap = {};

  final Map<String, List<String>> _oldTextsMap = {};

  final GlobalKey profileAvatarKey = GlobalKey();

  final List<String> _newLocales = [];
  final List<String> _oldLocales = [];
  late List<CategoryInfo> _oldCategories;
  late CategoryInfo? _oldCategory;

  bool _wasFocusRequest = false;

  bool needUpdateAccount = false;

  EditProfileCubit(
    this._cachingManager,
    this._userRepository,
    this._connectivityService,
    this._editProfileRepository,
  ) : super(const EditProfileState()) {
    final DetailedUserInfo? userInfoFromCache =
        _cachingManager.getDetailedUserInfo();
    final List<String> locales = userInfoFromCache?.locales ?? [];
    _oldLocales.addAll(locales);
    localesGlobalKeys = locales.map((e) => GlobalKey()).toList();

    final List<CategoryInfo>? advisorCategories = userInfoFromCache?.category;
    List<CategoryInfo> categories = [];
    if (advisorCategories != null) {
      categories = CategoryInfo.normalizeList(advisorCategories);
      _oldCategories = categories;
    }
    emit(state.copyWith(
      detailedUserInfo: userInfoFromCache,
      advisorMainLocale: userInfoFromCache?.details?.locale ?? 'en',
      advisorCategories: categories,
    ));

    _internetConnectionSubscription =
        _connectivityService.connectivityStream.listen((event) {
      if (event) {
        getData();
      }
    });

    getData();
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
    _internetConnectionSubscription.cancel();
    return super.close();
  }

  Future<void> getData() async {
    ///////////
    final bool mainIsDone = await _getMainSpeciality();
    final bool localesDescriptionsIsDone = await _setUpLocalesDescriptions();

    if (mainIsDone && localesDescriptionsIsDone) {
      _internetConnectionSubscription.cancel();
      emit(state.copyWith(
        canRefresh: false,
        advisorLocales: [..._oldLocales],
      ));
      _updateTextsFlag();
    }
    ////////////

    final BrandLocalesResponse response =
        await _editProfileRepository.getBrandLocales(AuthorizedRequest());

    if (response.status == true) {
      emit(
        state.copyWith(
          brands: response.result
              ?.map((e) => e.brand ?? const BrandModel())
              .toList(),
          avatars: response.result?.map((e) => null).toList() ?? [],
        ),
      );
    }
  }

  void selectBrandIndex(int index) {
    emit(state.copyWith(selectedBrandIndex: index));
  }

  void goToCategoriesList(BuildContext context) {
    List<int> selectedIds = [];

    state.brands?[state.selectedBrandIndex].fields?.categories
        ?.forEach((element) {
      if (element.id != null) {
        selectedIds.add(element.id!);
      }
    });

    context.push(route: ZodiacCategoriesList(selectedCategoryIds: selectedIds));
  }

  void _updateTextsFlag() {
    bool flag = state.updateTextsFlag;
    emit(state.copyWith(updateTextsFlag: !flag));
  }

  Future<bool> _getMainSpeciality() async {
    bool isOk = false;
    final MainSpecializationResponse response =
        await _userRepository.getMainSpeciality(AuthorizedRequest());
    final CategoryInfo? mainCategory = response.result;
    if (mainCategory != null) {
      _oldCategory = mainCategory;
      _changeMainCategory([mainCategory]);
      isOk = true;
    }
    return isOk;
  }

  void setAvatar(File avatar) {
    emit(state.copyWith(avatar: avatar));
  }

  String localeNativeName(String code) {
    List<LocaleModel>? locales = _cachingManager.getAllLocales();

    return locales
            ?.firstWhere((element) => element.code == code,
                orElse: () => const LocaleModel())
            .nameNative ??
        '';
  }

  void changeLocaleIndex(int newIndex) {
    emit(state.copyWith(currentLocaleIndex: newIndex));
    Utils.animateToWidget(localesGlobalKeys[newIndex]);
  }

  Future<bool> _setUpLocalesDescriptions() async {
    bool isOk = true;
    for (String locale in _oldLocales) {
      final LocaleDescriptionsResponse response =
          await _userRepository.getLocaleDescriptions(
        LocaleDescriptionsRequest(locale: locale),
      );
      final LocaleDescriptions? descriptions = response.result;
      if (response.status == true) {
        if (descriptions != null) {
          final List<String> texts = [];
          texts.insert(
            nickNameIndex,
            descriptions.nickname?.toString().trim() ?? '',
          );
          texts.insert(
            aboutIndex,
            Utils.parseHtmlString(descriptions.about?.toString().trim() ?? ''),
          );
          texts.insert(
            experienceIndex,
            Utils.parseHtmlString(
                descriptions.experience?.toString().trim() ?? ''),
          );
          texts.insert(
            helloMessageIndex,
            descriptions.helloMessage?.toString().trim() ?? '',
          );

          _oldTextsMap[locale] = texts;

          hasFocusNotifiersMap[locale] =
              texts.map((text) => ValueNotifier(false)).toList();
          errorTextsMap[locale] =
              texts.map((e) => ValidationErrorType.empty).toList();

          textControllersMap[locale] = texts.mapIndexed((index, text) {
            final TextEditingController controller = TextEditingController();
            controller.text = text;
            controller.addListener(() {
              errorTextsMap[locale]?[index] = ValidationErrorType.empty;
              _updateTextsFlag();
            });
            return controller;
          }).toList();
          focusNodesMap[locale] = texts.mapIndexed((index, text) {
            final FocusNode node = FocusNode();
            node.addListener(() {
              hasFocusNotifiersMap[locale]?[index].value = node.hasFocus;
            });
            return node;
          }).toList();
        }
      } else {
        isOk = false;
      }
    }
    return isOk;
  }

  Future<void> goToSelectAllCategories(BuildContext context) async {
    context.push(
        route: ZodiacSpecialitiesList(
            oldSelectedCategories: state.advisorCategories,
            returnCallback: (categories) {
              if (categories.isNotEmpty) {
                final int? mainCategoryId =
                    state.advisorMainCategory?.firstOrNull?.id;
                if (mainCategoryId != null &&
                    !categories
                        .map((e) => e.id)
                        .toList()
                        .contains(mainCategoryId)) {
                  _changeMainCategory([categories.first]);
                }
              }

              emit(state.copyWith(advisorCategories: categories));
            }));
  }

  Future<void> goToSelectMainCategory(BuildContext context) async {
    final List<CategoryInfo>? mainCategory = state.advisorMainCategory;
    final List<CategoryInfo> advisorCategories = state.advisorCategories;

    if (mainCategory != null && advisorCategories.isNotEmpty) {
      context.push(
        route: ZodiacSpecialitiesList(
            isMultiselect: false,
            allCategories: advisorCategories,
            oldSelectedCategories: mainCategory,
            returnCallback: (categories) {
              _changeMainCategory(categories);
            }),
      );
    }
  }

  Future<void> goToAddNewLocale(BuildContext context) async {
    context.push(
      route: ZodiacLocalesList(
        title: SZodiac.of(context).languageZodiac,
        unnecessaryLocalesCodes: state.advisorLocales,
        returnCallback: (locale) {
          _addLocaleLocally(locale);
        },
      ),
    );
  }

  Future<bool?> saveInfo() async {
    bool? isOk;

    final bool isOnline = await _connectivityService.checkConnection();

    final bool isChecked = _checkTextFields();

    if (isOnline && isChecked) {
      final int? newMainCategoryId = state.advisorMainCategory?.firstOrNull?.id;
      if (newMainCategoryId != null && newMainCategoryId != _oldCategory?.id) {
        final BaseResponse response = await _userRepository
            .changeMainSpecialization(ChangeMainSpecializationRequest(
          categoryId: newMainCategoryId,
        ));
        if (response.status == false) {
          isOk = false;
          return isOk;
        } else {
          _oldCategory = state.advisorMainCategory?.firstOrNull;
          isOk = true;
        }
      }

      final List<int> oldList = _oldCategories.map((e) => e.id ?? 0).toList();
      final List<int> newList =
          state.advisorCategories.map((e) => e.id ?? 0).toList();

      if (!unorderedDeepListEquals(oldList, newList)) {
        final BaseResponse response = await _userRepository
            .changeAdvisorSpecializations(ChangeAdvisorSpecializationsRequest(
          categories: newList,
        ));

        if (response.status == false) {
          isOk = false;
          return isOk;
        } else {
          _oldCategories = state.advisorCategories;
          isOk = true;
        }
      }

      for (String localeCode in _oldLocales) {
        final bool? isUpdated = await _updateAdvisorLocale(localeCode);
        if (isUpdated == false) {
          isOk = false;
          return isOk;
        } else if (isUpdated == true) {
          isOk = true;
        }
      }

      for (String localeCode in List.from(_newLocales)) {
        final bool isAdded = await _addAdvisorLocale(localeCode);
        if (isAdded == false) {
          isOk = false;
          return isOk;
        } else if (isAdded == true) {
          isOk = true;
        }
      }

      if (state.avatar != null) {
        final BaseResponse response = await _userRepository.uploadAvatar(
          request: AuthorizedRequest(),
          brandId: Brands.zodiac.id,
          avatar: state.avatar!,
        );
        if (response.status != true) {
          isOk = false;
          return isOk;
        } else {
          isOk = true;
        }
      }
    } else {
      _updateTextsFlag();
      isOk = false;
    }
    return isOk;
  }

  Future<bool> _addAdvisorLocale(String localeCode) async {
    bool isOk;

    final String? newNickName =
        textControllersMap[localeCode]?[nickNameIndex].text.trim();
    final String? newAbout =
        textControllersMap[localeCode]?[aboutIndex].text.trim();
    final String? newExperience =
        textControllersMap[localeCode]?[experienceIndex].text.trim();
    final String? newHelloMessage =
        textControllersMap[localeCode]?[helloMessageIndex].text.trim();

    final BaseResponse response = await _userRepository.addLocaleAdvisor(
      AddRemoveLocaleRequest(
          brandId: Brands.zodiac.id,
          localeCode: localeCode,
          data: LocaleDescriptions(
            nickname: newNickName,
            about: newAbout,
            experience: newExperience,
            helloMessage: newHelloMessage,
          )),
    );

    if (response.status == true) {
      final List<String> texts = [];
      texts.insert(
        nickNameIndex,
        newNickName ?? '',
      );
      texts.insert(
        aboutIndex,
        newAbout ?? '',
      );
      texts.insert(
        experienceIndex,
        newExperience ?? '',
      );
      texts.insert(
        helloMessageIndex,
        newHelloMessage ?? '',
      );

      _oldTextsMap[localeCode] = texts;
      _oldLocales.add(localeCode);
      _newLocales.remove(localeCode);
      isOk = true;
    } else {
      isOk = false;
    }

    return isOk;
  }

  Future<bool?> _updateAdvisorLocale(String localeCode) async {
    bool? isOk;

    final String? oldNickName = _oldTextsMap[localeCode]?[nickNameIndex];
    final String? oldAbout = _oldTextsMap[localeCode]?[aboutIndex];
    final String? oldExperience = _oldTextsMap[localeCode]?[experienceIndex];
    final String? oldHelloMessage =
        _oldTextsMap[localeCode]?[helloMessageIndex];

    final String? newNickName =
        textControllersMap[localeCode]?[nickNameIndex].text.trim();
    final String? newAbout =
        textControllersMap[localeCode]?[aboutIndex].text.trim();
    final String? newExperience =
        textControllersMap[localeCode]?[experienceIndex].text.trim();
    final String? newHelloMessage =
        textControllersMap[localeCode]?[helloMessageIndex].text.trim();

    logger.d(oldNickName);
    logger.d(newNickName);
    logger.d(oldNickName != newNickName);

    if (oldNickName != newNickName ||
        oldAbout != newAbout ||
        oldExperience != newExperience ||
        oldHelloMessage != newHelloMessage) {
      final BaseResponse response =
          await _userRepository.updateLocaleDescriptionsAdvisor(
        AddRemoveLocaleRequest(
            brandId: Brands.zodiac.id,
            localeCode: localeCode,
            data: LocaleDescriptions(
              nickname: newNickName,
              about: newAbout,
              experience: newExperience,
              helloMessage: newHelloMessage,
            )),
      );

      if (response.status == true) {
        final List<String> texts = [];
        texts.insert(
          nickNameIndex,
          newNickName ?? '',
        );
        texts.insert(
          aboutIndex,
          newAbout ?? '',
        );
        texts.insert(
          experienceIndex,
          newExperience ?? '',
        );
        texts.insert(
          helloMessageIndex,
          newHelloMessage ?? '',
        );

        _oldTextsMap[localeCode] = texts;
        isOk = true;
      } else {
        isOk = false;
      }
    }

    return isOk;
  }

  void _addLocaleLocally(String localeCode) {
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
    hasFocusNotifiersMap[localeCode] = List<ValueNotifier>.generate(
      _textFieldsCount,
      (index) => ValueNotifier(false),
    );
    errorTextsMap[localeCode] = List<ValidationErrorType>.generate(
      _textFieldsCount,
      (index) => index == nickNameIndex
          ? ValidationErrorType.theNicknameIsInvalidMustBe3to250Symbols
          : ValidationErrorType.requiredField,
    );

    textControllersMap[localeCode] = List<TextEditingController>.generate(
      _textFieldsCount,
      (index) {
        return TextEditingController()
          ..addListener(() {
            errorTextsMap[localeCode]?[index] = ValidationErrorType.empty;
            _updateTextsFlag();
          });
      },
    );
    focusNodesMap[localeCode] = List<FocusNode>.generate(
      _textFieldsCount,
      (index) {
        final node = FocusNode();
        node.addListener(() {
          hasFocusNotifiersMap[localeCode]?[index].value = node.hasFocus;
        });
        return node;
      },
    );

    localesGlobalKeys.add(GlobalKey());
  }

  Future<void> removeLocale(String localeCode) async {
    if (_newLocales.contains(localeCode)) {
      _removeLocaleLocally(localeCode);
    } else {
      final BaseResponse response =
          await _userRepository.removeLocaleAdvisor(AddRemoveLocaleRequest(
        brandId: Brands.zodiac.id,
        localeCode: localeCode,
      ));

      if (response.status == true) {
        needUpdateAccount = true;
        _removeLocaleLocally(localeCode);
      }
    }
  }

  void _removeLocaleLocally(String localeCode) {
    final List<String> locales = List.of(state.advisorLocales);
    final codeIndex = locales.indexOf(localeCode);
    int newLocaleIndex = state.currentLocaleIndex;

    if (codeIndex <= newLocaleIndex) {
      newLocaleIndex = newLocaleIndex - 1;
    }
    _removeLocaleProperties(localeCode);

    _newLocales.remove(localeCode);
    _oldLocales.remove(localeCode);

    emit(state.copyWith(
      advisorLocales: [..._oldLocales, ..._newLocales],
      currentLocaleIndex: newLocaleIndex,
    ));
  }

  void _removeLocaleProperties(String localeCode) {
    for (TextEditingController element
        in textControllersMap[localeCode] ?? []) {
      element.dispose();
    }
    for (FocusNode element in focusNodesMap[localeCode] ?? []) {
      element.dispose();
    }
    for (ValueNotifier element in hasFocusNotifiersMap[localeCode] ?? []) {
      element.dispose();
    }

    textControllersMap.remove(localeCode);
    focusNodesMap.remove(localeCode);
    hasFocusNotifiersMap.remove(localeCode);
    errorTextsMap.remove(localeCode);

    localesGlobalKeys.removeAt(state.advisorLocales.indexOf(localeCode));
  }

  bool _checkTextFields() {
    bool isValid = true;
    int? firstLanguageWithErrorIndex;
    final List<String> locales = List.from(state.advisorLocales);
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

      errorTextsMap[localeCode]?[nickNameIndex] = isShort
          ? ValidationErrorType.theNicknameIsInvalidMustBe3to250Symbols
          : ValidationErrorType.characterLimitExceeded;

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

      errorTextsMap[localeCode]?[index] = isShort
          ? ValidationErrorType.requiredField
          : ValidationErrorType.characterLimitExceeded;

      if (!_wasFocusRequest) {
        focusNodesMap[localeCode]?[index].requestFocus();
      }
    }
    return isValid;
  }

  void _changeMainCategory(List<CategoryInfo> mainCategory) {
    emit(state.copyWith(advisorMainCategory: mainCategory));
  }
}
