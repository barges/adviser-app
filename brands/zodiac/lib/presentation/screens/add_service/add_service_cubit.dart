import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/data/models/services/service_info_item.dart';
import 'package:zodiac/data/models/services/service_language_model.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/data/network/requests/add_service_request.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/add_service_response.dart';
import 'package:zodiac/data/network/responses/default_services_images_response.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_state.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/delivery_time_slider_widget.dart';
import 'package:zodiac/zodiac_constants.dart';

const double minPrice = 4.99;
const double maxPrice = 299.99;

const int _textFieldsCount = 2;

@injectable
class AddServiceCubit extends Cubit<AddServiceState> {
  final ZodiacCachingManager _zodiacCachingManager;
  final ZodiacServicesRepository _servicesRepository;
  final ZodiacUserRepository _userRepository;
  final GlobalCachingManager _globalCachingManager;

  List<GlobalKey> localesGlobalKeys = [];
  final Map<String, List<TextEditingController>> textControllersMap = {};
  final Map<String, List<FocusNode>> focusNodesMap = {};
  final Map<String, List<ValueNotifier>> hasFocusNotifiersMap = {};
  final Map<String, List<ValidationErrorType>> errorTextsMap = {};

  bool _wasFocusRequest = false;
  int? _duplicatedServiceId;

  AddServiceCubit(
    this._zodiacCachingManager,
    this._servicesRepository,
    this._userRepository,
    this._globalCachingManager,
  ) : super(const AddServiceState()) {
    initializeScreen();
  }

  @override
  Future<void> close() async {
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
    super.close();
  }

  Future<void> initializeScreen() async {
    try {
      await _getInitLanguage();
      await _getImages();
    } catch (e) {
      logger.d(e);
    } finally {
      emit(state.copyWith(alreadyTriedToGetImages: true));
    }
  }

  Future<void> _getInitLanguage() async {
    if (_zodiacCachingManager.haveLocales) {
      _setInitLanguage();
    } else {
      List<LocaleModel>? responseLocales =
          ((await _userRepository.getAllLocales(AuthorizedRequest())).result);
      if (responseLocales != null) {
        _zodiacCachingManager.saveAllLocales(responseLocales);
        _setInitLanguage();
      }
    }
  }

  void _setInitLanguage() {
    String initLanguageCode = _globalCachingManager.getLanguageCode() ?? 'en';
    emit(state.copyWith(languagesList: [initLanguageCode]));
    _setNewLocaleProperties(initLanguageCode, onStart: true);
  }

  void goToAddNewLocale(BuildContext context) {
    context.push(
      route: ZodiacLocalesList(
        title: SZodiac.of(context).serviceLanguageZodiac,
        unnecessaryLocalesCodes: state.languagesList,
        returnCallback: (locale) {
          _addLocaleLocally(locale);
        },
      ),
    );
  }

  void goToDuplicateService(BuildContext context) {
    context.push(
        route: ZodiacDuplicateService(
      returnCallback: duplicateService,
      oldDuplicatedServiceId: _duplicatedServiceId,
    ));
  }

  void duplicateService(Map<String, dynamic> params) {
    final String name = params['name'];
    final ServiceInfoItem duplicatedService = params['duplicatedService'];

    _duplicatedServiceId = duplicatedService.id;

    final List<String>? languagesList = state.languagesList;
    if (languagesList != null) {
      for (String element in languagesList) {
        removeLocale(element);
      }
    }

    final List<String> _newLanguagesList = [];
    duplicatedService.translations?.forEach((element) {
      if (element.code != null) {
        _newLanguagesList.add(element.code!);
        _addLocaleLocally(element.code!);
        _setupLanguageTexts(
            element.code!, element.title ?? '', element.description ?? '');
      }
    });

    duplicatedService.approval?.forEach((element) {
      if (element.code != null) {
        _newLanguagesList.add(element.code!);
        _addLocaleLocally(element.code!);
        _setupLanguageTexts(element.code!, element.title?.value ?? '',
            element.description?.value ?? '');
      }
    });

    DeliveryTimeTabType? deliveryTimeTabType =
        DeliveryTimeTabType.fromSeconds(duplicatedService.duration);

    emit(
      state.copyWith(
          languagesList: _newLanguagesList,
          duplicatedServiceName: name,
          price: duplicatedService.price ?? 9.99,
          selectedDeliveryTimeTab:
              deliveryTimeTabType ?? DeliveryTimeTabType.minutes,
          deliveryTime: deliveryTimeTabType
                  ?.deliveryTimeFromSeconds(duplicatedService.duration) ??
              20,
          mainLanguageIndex: _newLanguagesList
              .indexWhere((element) => element == duplicatedService.mainLocale),
          selectedLanguageIndex: 0,
          updateAfterDuplicate: !state.updateAfterDuplicate),
    );
  }

  void _setupLanguageTexts(
      String localeCode, String title, String description) {
    textControllersMap[localeCode]?[ZodiacConstants.serviceTitleIndex].text =
        title;
    textControllersMap[localeCode]?[ZodiacConstants.serviceDescriptionIndex]
        .text = description;
  }

  String localeNativeName(String code) {
    List<LocaleModel>? locales = _zodiacCachingManager.getAllLocales();

    return locales
            ?.firstWhere((element) => element.code == code,
                orElse: () => const LocaleModel())
            .nameNative ??
        '';
  }

  void changeLocaleIndex(int newIndex) {
    emit(state.copyWith(selectedLanguageIndex: newIndex));
    Utils.animateToWidget(localesGlobalKeys[newIndex]);
  }

  void _addLocaleLocally(String localeCode) {
    final List<String> locales = List.from(state.languagesList ?? []);
    locales.add(localeCode);
    _setNewLocaleProperties(localeCode);

    emit(state.copyWith(languagesList: locales));

    final codeIndex = locales.indexOf(localeCode);
    if (codeIndex != -1) {
      changeLocaleIndex(codeIndex);
    }
  }

  void _setNewLocaleProperties(String localeCode, {bool onStart = false}) {
    errorTextsMap[localeCode] = List<ValidationErrorType>.generate(
      _textFieldsCount,
      (index) => onStart
          ? ValidationErrorType.empty
          : ValidationErrorType.requiredField,
    );

    textControllersMap[localeCode] = List<TextEditingController>.generate(
      _textFieldsCount,
      (index) {
        return TextEditingController()
          ..addListener(() {
            if (errorTextsMap[localeCode]?[index] !=
                ValidationErrorType.empty) {
              errorTextsMap[localeCode]?[index] = ValidationErrorType.empty;
              _updateTextsFlag();
            }
          });
      },
    );

    hasFocusNotifiersMap[localeCode] = List<ValueNotifier>.generate(
      _textFieldsCount,
      (index) => ValueNotifier(false),
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

  void _updateTextsFlag() {
    bool flag = state.updateTextsFlag;
    emit(state.copyWith(updateTextsFlag: !flag));
  }

  void setMainLanguage(int index) {
    if (state.mainLanguageIndex == index) {
      emit(state.copyWith(mainLanguageIndex: null));
    } else {
      emit(state.copyWith(mainLanguageIndex: index));
    }
  }

  Future<void> removeLocale(String localeCode) async {
    _removeLocaleLocally(localeCode);
  }

  void _removeLocaleLocally(String localeCode) {
    final List<String> locales = List.of(state.languagesList ?? []);
    final codeIndex = locales.indexOf(localeCode);
    int newLocaleIndex = state.selectedLanguageIndex;

    if (codeIndex <= newLocaleIndex && codeIndex != 0) {
      newLocaleIndex = newLocaleIndex - 1;
    }
    _removeLocaleProperties(localeCode);

    locales.remove(localeCode);

    emit(state.copyWith(
      languagesList: List.of(locales),
      selectedLanguageIndex: newLocaleIndex,
    ));

    if (locales.length == 1) {
      emit(state.copyWith(mainLanguageIndex: 0));
    }
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

    localesGlobalKeys.removeAt(state.languagesList!.indexOf(localeCode));
  }

  void onPriceChanged(dynamic value) {
    if (value >= minPrice && value <= maxPrice) {
      emit(state.copyWith(price: value));
    }
  }

  void onDeliveryTimeTabChanged(DeliveryTimeTabType value) {
    if (value != state.selectedDeliveryTimeTab) {
      emit(
        state.copyWith(
          selectedDeliveryTimeTab: value,
          deliveryTime: value.defaultValue,
        ),
      );
    }
  }

  void onDeliveryTimeChanged(dynamic value) {
    if (value >= state.selectedDeliveryTimeTab.min &&
        value <= state.selectedDeliveryTimeTab.max) {
      emit(state.copyWith(deliveryTime: value));
    }
  }

  void onDiscountChanged(dynamic value) {
    if (value >= ZodiacConstants.serviceMinDiscount &&
        value <= ZodiacConstants.serviceMaxDiscount) {
      emit(state.copyWith(discount: value));
    }
  }

  void onDiscountEnabledChanged(bool value) {
    emit(state.copyWith(discountEnabled: value));
  }

  Future<void> _getImages() async {
    final DefaultServicesImagesResponse response =
        await _servicesRepository.getDefaultImages(AuthorizedRequest());

    if (response.status == true) {
      List<ImageSampleModel>? images = response.samples;

      emit(state.copyWith(images: images));
    }
  }

  void setShowAllImages() {
    emit(state.copyWith(showAllImages: !state.showAllImages));
  }

  void selectImage(int index) {
    emit(state.copyWith(selectedImageIndex: index));
  }

  Future<bool> sendForApproval(BuildContext context) async {
    final bool isChecked = _checkTextFields();

    final List<ImageSampleModel>? images = state.images;
    if (isChecked && images != null && state.languagesList != null) {
      final List<ServiceLanguageModel> translations = [];
      for (String element in state.languagesList!) {
        translations.add(
          ServiceLanguageModel(
            code: element,
            title: textControllersMap[element]
                    ?[ZodiacConstants.serviceTitleIndex]
                .text,
            description: textControllersMap[element]
                    ?[ZodiacConstants.serviceDescriptionIndex]
                .text,
          ),
        );
      }
      final AddServiceRequest request = AddServiceRequest(
        price: state.price,
        duration:
            state.selectedDeliveryTimeTab.toSeconds(state.deliveryTime.toInt()),
        type: state.selectedTab,
        imageAlias: images[state.selectedImageIndex].imageAlias ?? '',
        mainLocale:
            state.mainLanguageIndex != null && state.languagesList != null
                ? state.languagesList![state.mainLanguageIndex!]
                : null,
        translations: translations,
      );

      AddServiceResponse response =
          await _servicesRepository.addService(request);

      if (response.status == true) {
        // ignore: use_build_context_synchronously
        context.pop();
        return true;
      }
    }
    return false;
  }

  bool _checkTextFields() {
    bool isValid = true;
    int? firstLanguageWithErrorIndex;
    final List<String> languagesList = List.from(state.languagesList ?? []);
    for (String localeCode in languagesList) {
      final List<TextEditingController>? controllersByLocale =
          textControllersMap[localeCode];
      if (controllersByLocale != null) {
        for (int i = 0; i < controllersByLocale.length; i++) {
          if (!_checkTextField(localeCode, i)) {
            firstLanguageWithErrorIndex ??= languagesList.indexOf(localeCode);
            _wasFocusRequest = true;
            isValid = false;
          }

          if (localeCode == languagesList.lastOrNull &&
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

  bool _checkTextField(String localeCode, int index) {
    bool isValid = true;
    final String text =
        textControllersMap[localeCode]?[index].text.trim() ?? '';
    if (text.isEmpty) {
      isValid = false;

      errorTextsMap[localeCode]?[index] = ValidationErrorType.requiredField;

      if (!_wasFocusRequest) {
        focusNodesMap[localeCode]?[index].requestFocus();
      }
    }
    return isValid;
  }
}
