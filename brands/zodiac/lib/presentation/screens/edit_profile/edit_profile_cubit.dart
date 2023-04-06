import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/brands.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/data/models/user_info/locale_descriptions.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/locale_descriptions_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/locale_descriptions_response.dart';
import 'package:zodiac/data/network/responses/main_specialization_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

const int _textFieldsCount = 4;

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

  EditProfileCubit(
    this._mainCubit,
    this._cachingManager,
    this._userRepository,
  ) : super(const EditProfileState()) {
    final DetailedUserInfo? userInfoFromCache =
        _cachingManager.getDetailedUserInfo();

    final List<String> locales = userInfoFromCache?.locales ?? [];
    localesGlobalKeys = locales.map((e) => GlobalKey()).toList();

    final List<CategoryInfo> categories = [];
    final List<CategoryInfo>? advisorCategories = userInfoFromCache?.category;

    if (advisorCategories != null) {
      for (CategoryInfo categoryInfo in advisorCategories) {
        categories.add(categoryInfo);
        List<CategoryInfo>? sublist = categoryInfo.sublist;
        if (sublist != null) {
          for (CategoryInfo subCategoryInfo in sublist) {
            categories.add(subCategoryInfo);
          }
        }
      }
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

  void addLocaleLocally(LocaleModel localeModel) {
    final String? localeCode = localeModel.code;
    if (localeCode != null) {
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
  }

  void _setNewLocaleProperties(String locale) {
    textControllersMap[locale] = List<TextEditingController>.generate(
      _textFieldsCount,
      (index) => TextEditingController(),
    );
    focusNodesMap[locale] = List<FocusNode>.generate(
      _textFieldsCount,
      (index) => FocusNode(),
    );
    hasFocusNotifiersMap[locale] = List<ValueNotifier>.generate(
      _textFieldsCount,
      (index) => ValueNotifier(false),
    );
    errorTextsMap[locale] = List<ValidationErrorType>.generate(
      _textFieldsCount,
      (index) => ValidationErrorType.empty,
    );

    final List<FocusNode>? nodes = focusNodesMap[locale];
    if (nodes != null) {
      for (int i = 0; i < nodes.length; i++) {
        nodes[i].addListener(() {
          hasFocusNotifiersMap[locale]?[i].value = nodes[i].hasFocus;
        });
      }
    }
    localesGlobalKeys.add(GlobalKey());
  }

  Future<void> saveInfo() async {
    if (state.avatar != null) {
      final BaseResponse response = await _userRepository.uploadAvatar(
        request: AuthorizedRequest(),
        brandId: Brands.zodiac.id,
        avatar: state.avatar!,
      );
    }
  }

  void updateMainCategory(List<CategoryInfo> mainCategory) {
    emit(state.copyWith(advisorMainCategory: mainCategory));
  }
}
