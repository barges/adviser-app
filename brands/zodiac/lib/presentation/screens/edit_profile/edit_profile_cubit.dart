import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/edit_profile/brand_locale_model.dart';
import 'package:zodiac/data/models/edit_profile/brand_model.dart';
import 'package:zodiac/data/models/edit_profile/profile_avatar_model.dart';
import 'package:zodiac/data/models/edit_profile/saved_brand_locales_model.dart';
import 'package:zodiac/data/models/edit_profile/saved_brand_model.dart';
import 'package:zodiac/data/models/edit_profile/saved_locale_model.dart';
import 'package:zodiac/data/models/enums/approval_status.dart';

import 'package:zodiac/data/models/enums/profile_field.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/save_brand_locales_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/brand_locales_response.dart';
import 'package:zodiac/domain/repositories/zodiac_edit_profile_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_state.dart';

const int _textFieldsCount = 4;

int nickNameIndex = ProfileField.nicknameIndex;
int aboutIndex = ProfileField.aboutIndex;
int experienceIndex = ProfileField.experienceIndex;
int helloMessageIndex = ProfileField.helloMessageIndex;

@injectable
class EditProfileCubit extends Cubit<EditProfileState> {
  final ZodiacCachingManager _cachingManager;
  final ConnectivityService _connectivityService;
  final ZodiacEditProfileRepository _editProfileRepository;

  late final StreamSubscription<bool> _internetConnectionSubscription;
  List<List<GlobalKey>> localesGlobalKeys = [];
  List<String> mainLocales = [];

  final List<Map<String, List<TextEditingController>>> textControllersMap = [];
  final List<Map<String, List<FocusNode>>> focusNodesMap = [];
  final List<Map<String, List<ValueNotifier>>> hasFocusNotifiersMap = [];
  final List<Map<String, List<ValidationErrorType>>> errorTextsMap = [];
  final List<Map<String, List<ApprovalStatus>>> approvalStatusMap = [];

  final List<GlobalKey> profileAvatarKeys = [];

  ////////
  final List<int?> _mainCategoryIds = [];
  final List<int?> _mainMethodIds = [];
  ////////

  bool _wasFocusRequest = false;

  bool needUpdateAccount = false;

  bool _dataIsLoading = false;

  EditProfileCubit(
    this._cachingManager,
    this._connectivityService,
    this._editProfileRepository,
  ) : super(const EditProfileState()) {
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
    for (var element in textControllersMap) {
      for (var entry in element.entries) {
        for (var element in entry.value) {
          element.dispose();
        }
      }
    }

    for (var element in focusNodesMap) {
      for (var entry in element.entries) {
        for (var element in entry.value) {
          element.dispose();
        }
      }
    }

    for (var element in hasFocusNotifiersMap) {
      for (var entry in element.entries) {
        for (var element in entry.value) {
          element.dispose();
        }
      }
    }

    _internetConnectionSubscription.cancel();
    return super.close();
  }

  Future<void> getData() async {
    if (!_dataIsLoading) {
      _dataIsLoading = true;
      try {
        textControllersMap.clear();
        focusNodesMap.clear();
        hasFocusNotifiersMap.clear();
        errorTextsMap.clear();
        mainLocales.clear();
        localesGlobalKeys.clear();
        profileAvatarKeys.clear();

        final BrandLocalesResponse response =
            await _editProfileRepository.getBrandLocales(AuthorizedRequest());

        if (response.status == true) {
          List<BrandModel>? brands = response.result
              ?.map((e) => e.brand ?? const BrandModel())
              .toList();
          List<List<BrandLocaleModel>>? locales = response.result
              ?.map((e) => e.locales ?? List<BrandLocaleModel>.empty())
              .toList();

          brands?.forEach(
            (element) {
              _mainCategoryIds.add(element.fields?.mainCategoryId);
              _mainMethodIds.add(element.fields?.mainMethodId);
              profileAvatarKeys.add(GlobalKey());
            },
          );

          List<List<String>> brandLocales = [];

          locales?.forEachIndexed((brandIndex, locales) {
            brandLocales.add(locales.map((e) => e.locale?.code ?? '').toList());
            textControllersMap.add({});
            focusNodesMap.add({});
            hasFocusNotifiersMap.add({});
            errorTextsMap.add({});
            approvalStatusMap.add({});
            localesGlobalKeys.add([]);

            mainLocales.add('');

            for (BrandLocaleModel item in locales) {
              _setUpLocalesDescriptions(item, brandIndex);
              if (item.locale?.isDefault == true) {
                mainLocales[brandIndex] = item.locale?.code ?? '';
              }
            }
          });

          emit(
            state.copyWith(
              brands: brands,
              avatars: response.result
                      ?.map((e) => const ProfileAvatarModel())
                      .toList() ??
                  [],
              advisorCategories:
                  brands?.map((e) => e.fields?.categories ?? []).toList() ?? [],
              advisorMethods:
                  brands?.map((e) => e.fields?.methods ?? []).toList() ?? [],
              brandLocales: brandLocales,
              currentLocaleIndexes: brands?.map((e) => 0).toList() ?? [],
            ),
          );

          _internetConnectionSubscription.cancel();
        }
      } catch (e) {
        logger.d(e);
      } finally {
        _dataIsLoading = false;
      }
    }
  }

  void selectBrandIndex(int index) {
    emit(state.copyWith(selectedBrandIndex: index));
  }

  void goToSelectCategories(BuildContext context) {
    List<int> selectedIds = [];

    for (var element in state.advisorCategories[state.selectedBrandIndex]) {
      if (element.id != null) {
        selectedIds.add(element.id!);
      }
    }

    final int? mainCategoryId = _mainCategoryIds[state.selectedBrandIndex];

    context.push(
        route: ZodiacSelectCategories(
      selectedCategoryIds: selectedIds,
      mainCategoryId: mainCategoryId,
      returnCallback: _setCategories,
    ));
  }

  void _setCategories(List<CategoryInfo> categories, int mainCategoryId) {
    List<List<CategoryInfo>> newCategories = List.of(state.advisorCategories);

    newCategories[state.selectedBrandIndex] = categories;
    _mainCategoryIds[state.selectedBrandIndex] = mainCategoryId;

    emit(state.copyWith(advisorCategories: newCategories));
  }

  void goToSelectMethods(BuildContext context) {
    List<int> selectedIds = [];

    for (var element in state.advisorMethods[state.selectedBrandIndex]) {
      if (element.id != null) {
        selectedIds.add(element.id!);
      }
    }

    final int? mainMethodId = _mainMethodIds[state.selectedBrandIndex];

    context.push(
        route: ZodiacSelectMethods(
      selectedMethodIds: selectedIds,
      mainMethodId: mainMethodId,
      returnCallback: _setMethods,
    ));
  }

  void _setMethods(List<CategoryInfo> methods, int mainMethodId) {
    List<List<CategoryInfo>> newMethods = List.of(state.advisorMethods);

    newMethods[state.selectedBrandIndex] = methods;
    _mainMethodIds[state.selectedBrandIndex] = mainMethodId;

    emit(state.copyWith(advisorMethods: newMethods));
  }

  void _updateTextsFlag() {
    bool flag = state.updateTextsFlag;
    emit(state.copyWith(updateTextsFlag: !flag));
  }

  void setAvatar(File avatar) {
    List<ProfileAvatarModel> avatars = List.of(state.avatars);

    int selectedBrandIndex = state.selectedBrandIndex;

    avatars[selectedBrandIndex] = ProfileAvatarModel(
        brandId: state.brands?[selectedBrandIndex].id, image: avatar);

    int? brandIndexWithAvatarError = state.brandIndexWithAvatarError;

    emit(state.copyWith(
      avatars: avatars,
      brandIndexWithAvatarError: selectedBrandIndex == brandIndexWithAvatarError
          ? null
          : brandIndexWithAvatarError,
    ));
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
    List<int> currentLocaleIndexes = List.of(state.currentLocaleIndexes);

    currentLocaleIndexes[state.selectedBrandIndex] = newIndex;

    emit(state.copyWith(currentLocaleIndexes: currentLocaleIndexes));
    Utils.animateToWidget(
        localesGlobalKeys[state.selectedBrandIndex][newIndex]);
  }

  void _setUpLocalesDescriptions(
      BrandLocaleModel brandLocaleModel, int brandIndex) async {
    String? locale = brandLocaleModel.locale?.code;

    if (locale != null) {
      final List<String> texts = [];
      texts.insert(
        nickNameIndex,
        brandLocaleModel.fields?.nickname?.toString().trim() ?? '',
      );
      texts.insert(
        aboutIndex,
        Utils.parseHtmlString(
            brandLocaleModel.fields?.about?.toString().trim() ?? ''),
      );
      texts.insert(
        experienceIndex,
        Utils.parseHtmlString(
            brandLocaleModel.fields?.experience?.toString().trim() ?? ''),
      );
      texts.insert(
        helloMessageIndex,
        brandLocaleModel.fields?.helloMessage?.toString().trim() ?? '',
      );

      hasFocusNotifiersMap[brandIndex][locale] =
          texts.map((text) => ValueNotifier(false)).toList();
      errorTextsMap[brandIndex][locale] =
          texts.map((e) => ValidationErrorType.empty).toList();

      textControllersMap[brandIndex][locale] = texts.mapIndexed((index, text) {
        final TextEditingController controller = TextEditingController();
        controller.text = text;
        controller.addListener(() {
          errorTextsMap[brandIndex][locale]?[index] = ValidationErrorType.empty;
          _updateTextsFlag();
        });
        return controller;
      }).toList();
      focusNodesMap[brandIndex][locale] = texts.mapIndexed((index, text) {
        final FocusNode node = FocusNode();
        node.addListener(() {
          hasFocusNotifiersMap[brandIndex][locale]?[index].value =
              node.hasFocus;
        });
        return node;
      }).toList();

      approvalStatusMap[brandIndex][locale] =
          List.generate(_textFieldsCount, (index) => ApprovalStatus.approved);

      brandLocaleModel.pendingApproval?.forEach((element) {
        approvalStatusMap[brandIndex][locale]?[element.index] =
            ApprovalStatus.newStatus;
      });

      localesGlobalKeys[brandIndex].add(GlobalKey());
    }
  }

  Future<void> goToAddNewLocale(BuildContext context) async {
    context.push(
      route: ZodiacLocalesList(
        title: SZodiac.of(context).languageZodiac,
        unnecessaryLocalesCodes: state.brandLocales[state.selectedBrandIndex],
        returnCallback: (locale) {
          _addLocaleLocally(locale);
        },
      ),
    );
  }

  void _addLocaleLocally(String localeCode) {
    final int selectedBrandIndex = state.selectedBrandIndex;
    final List<List<String>> locales = List.from(state.brandLocales);
    locales[selectedBrandIndex].add(localeCode);

    _setNewLocaleProperties(localeCode, selectedBrandIndex);

    emit(state.copyWith(brandLocales: locales));

    final codeIndex = locales[selectedBrandIndex].indexOf(localeCode);
    if (codeIndex != -1) {
      changeLocaleIndex(codeIndex);
    }
  }

  void _setNewLocaleProperties(String localeCode, int brandIndex) {
    hasFocusNotifiersMap[brandIndex][localeCode] = List<ValueNotifier>.generate(
      _textFieldsCount,
      (index) => ValueNotifier(false),
    );
    errorTextsMap[brandIndex][localeCode] = List<ValidationErrorType>.generate(
      _textFieldsCount,
      (index) => index == nickNameIndex
          ? ValidationErrorType.theNicknameIsInvalidMustBe3to250Symbols
          : ValidationErrorType.requiredField,
    );

    textControllersMap[brandIndex][localeCode] =
        List<TextEditingController>.generate(
      _textFieldsCount,
      (index) {
        return TextEditingController()
          ..addListener(() {
            errorTextsMap[brandIndex][localeCode]?[index] =
                ValidationErrorType.empty;
            _updateTextsFlag();
          });
      },
    );
    focusNodesMap[brandIndex][localeCode] = List<FocusNode>.generate(
      _textFieldsCount,
      (index) {
        final node = FocusNode();
        node.addListener(() {
          hasFocusNotifiersMap[brandIndex][localeCode]?[index].value =
              node.hasFocus;
        });
        return node;
      },
    );

    localesGlobalKeys[brandIndex].add(GlobalKey());
  }

  Future<void> removeLocale(String localeCode) async {
    _removeLocaleLocally(localeCode);
  }

  void _removeLocaleLocally(String localeCode) {
    final int selectedBrandIndex = state.selectedBrandIndex;
    final List<List<String>> locales = List.of(state.brandLocales);
    final codeIndex = locales[selectedBrandIndex].indexOf(localeCode);
    final List<int> currentLocaleIndexes = List.of(state.currentLocaleIndexes);
    int newLocaleIndex = currentLocaleIndexes[selectedBrandIndex];

    if (codeIndex <= newLocaleIndex) {
      currentLocaleIndexes[selectedBrandIndex] = newLocaleIndex - 1;
    }
    _removeLocaleProperties(localeCode, selectedBrandIndex);

    locales[selectedBrandIndex].remove(localeCode);

    emit(state.copyWith(
      brandLocales: locales,
      currentLocaleIndexes: currentLocaleIndexes,
    ));
  }

  void _removeLocaleProperties(String localeCode, int brandIndex) {
    for (TextEditingController element
        in textControllersMap[brandIndex][localeCode] ?? []) {
      element.dispose();
    }
    for (FocusNode element in focusNodesMap[brandIndex][localeCode] ?? []) {
      element.dispose();
    }
    for (ValueNotifier element
        in hasFocusNotifiersMap[brandIndex][localeCode] ?? []) {
      element.dispose();
    }

    textControllersMap[brandIndex].remove(localeCode);
    focusNodesMap[brandIndex].remove(localeCode);
    hasFocusNotifiersMap[brandIndex].remove(localeCode);
    errorTextsMap[brandIndex].remove(localeCode);

    localesGlobalKeys[brandIndex]
        .removeAt(state.brandLocales[brandIndex].indexOf(localeCode));
  }

  bool _checkTextFields() {
    bool isValid = true;
    int? firstLanguageWithErrorIndex;
    int? firstBrandWithErrorIndex;

    List<List<String>> brandLocales = List.from(state.brandLocales);

    brandLocales.forEachIndexed((brandIndex, element) {
      final List<String> locales = List.from(element);
      for (String localeCode in locales) {
        final List<TextEditingController>? controllersByLocale =
            textControllersMap[brandIndex][localeCode];
        if (controllersByLocale != null) {
          for (int i = 0; i < controllersByLocale.length; i++) {
            if (i == nickNameIndex) {
              if (!_checkNickName(localeCode, brandIndex)) {
                firstLanguageWithErrorIndex ??= locales.indexOf(localeCode);
                firstBrandWithErrorIndex ??= brandIndex;
                _wasFocusRequest = true;
                isValid = false;
              }
            } else {
              if (!_checkTextField(localeCode, i, brandIndex)) {
                firstLanguageWithErrorIndex ??= locales.indexOf(localeCode);
                firstBrandWithErrorIndex ??= brandIndex;
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
    });

    if (firstBrandWithErrorIndex != null &&
        firstLanguageWithErrorIndex != null) {
      selectBrandIndex(firstBrandWithErrorIndex!);
      changeLocaleIndex(firstLanguageWithErrorIndex!);
      _updateTextsFlag();
    }
    return isValid;
  }

  bool _checkNickName(String localeCode, int brandIndex) {
    bool isValid = true;
    final String nickName = textControllersMap[brandIndex][localeCode]
                ?[nickNameIndex]
            .text
            .trim() ??
        '';
    final bool isShort = nickName.length < 3;
    final bool isLong = nickName.length > 250;
    if (isShort || isLong) {
      isValid = false;

      errorTextsMap[brandIndex][localeCode]?[nickNameIndex] = isShort
          ? ValidationErrorType.theNicknameIsInvalidMustBe3to250Symbols
          : ValidationErrorType.characterLimitExceeded;

      if (!_wasFocusRequest) {
        focusNodesMap[brandIndex][localeCode]?[nickNameIndex].requestFocus();
      }
    }
    return isValid;
  }

  bool _checkTextField(String localeCode, int index, int brandIndex) {
    bool isValid = true;
    final String text =
        textControllersMap[brandIndex][localeCode]?[index].text.trim() ?? '';
    final bool isShort = text.isEmpty;
    final bool isLong = text.length > 65000;
    if (isShort || isLong) {
      isValid = false;

      errorTextsMap[brandIndex][localeCode]?[index] = isShort
          ? ValidationErrorType.requiredField
          : ValidationErrorType.characterLimitExceeded;

      if (!_wasFocusRequest) {
        focusNodesMap[brandIndex][localeCode]?[index].requestFocus();
      }
    }
    return isValid;
  }

  Future<bool?> saveInfo() async {
    bool? isOk;

    try {
      final bool isOnline = await _connectivityService.checkConnection();

      final bool isChecked = _checkTextFields();

      if (isOnline && isChecked) {
        List<SavedBrandLocalesModel> brandLocales = [];

        List<BrandModel>? brands = state.brands;
        List<List<CategoryInfo>> advisorCategories =
            List.from(state.advisorCategories);
        List<List<CategoryInfo>> advisorMethods =
            List.from(state.advisorMethods);

        brands?.forEachIndexed((index, element) {
          if (element.id != null) {
            List<int> categoryIds = [];
            List<int> methodIds = [];

            for (var element in advisorCategories[index]) {
              if (element.id != null) {
                categoryIds.add(element.id!);
              }
            }

            for (var element in advisorMethods[index]) {
              if (element.id != null) {
                methodIds.add(element.id!);
              }
            }

            SavedBrandModel brand = SavedBrandModel(
                brandId: element.id!,
                categories: categoryIds,
                mainCategoryId: _mainCategoryIds[index] ?? 0,
                methods: methodIds,
                mainMethodId: _mainMethodIds[index] ?? 0);

            List<SavedLocaleModel> locales = state.brandLocales[index]
                .map((e) => _getLocaleModelFromFields(e, index))
                .toList();

            brandLocales
                .add(SavedBrandLocalesModel(brand: brand, locales: locales));
          }
        });

        BaseResponse response = await _editProfileRepository.saveBrandLocales(
            SaveBrandLocalesRequest(brandLocales: brandLocales));

        if (response.status == true) {
          isOk = true;

          List<ProfileAvatarModel> avatars = List.from(state.avatars);

          for (int i = 0; i < avatars.length; i++) {
            File? avatarFile = avatars[i].image;
            int? brandId = avatars[i].brandId;

            if (avatarFile != null && brandId != null) {
              BaseResponse response = await _editProfileRepository.uploadAvatar(
                  request: AuthorizedRequest(),
                  brandId: brandId,
                  avatar: avatarFile);

              if (response.status != true) {
                isOk = false;
                emit(state.copyWith(
                    brandIndexWithAvatarError: i, selectedBrandIndex: i));
                BuildContext? context = profileAvatarKeys[i].currentContext;
                if (context != null) {
                  // ignore: use_build_context_synchronously
                  Scrollable.ensureVisible(context, alignment: 1.0);
                }
                break;
              }
            }
          }
        } else {
          isOk = false;
        }
      } else {
        isOk = false;
      }
    } catch (e) {
      logger.d(e);

      isOk = false;
    }

    return isOk;
  }

  SavedLocaleModel _getLocaleModelFromFields(
      String localeCode, int brandIndex) {
    SavedLocaleModel result = SavedLocaleModel(
        localeCode: localeCode,
        about:
            textControllersMap[brandIndex][localeCode]?[aboutIndex].text ?? '',
        experience:
            textControllersMap[brandIndex][localeCode]?[experienceIndex].text ??
                '',
        nickname:
            textControllersMap[brandIndex][localeCode]?[nickNameIndex].text ??
                '',
        helloMessage: textControllersMap[brandIndex][localeCode]
                    ?[helloMessageIndex]
                .text ??
            '');

    return result;
  }
}
