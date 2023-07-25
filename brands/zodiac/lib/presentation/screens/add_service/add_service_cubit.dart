import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_state.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/delivery_time_slider_widget.dart';

const double minPrice = 4.99;
const double maxPrice = 299.99;

const double minDiscount = 5;
const double maxDiscount = 50;

const int _textFieldsCount = 2;

const int titleIndex = 0;
const int descriptionIndex = 1;

class AddServiceCubit extends Cubit<AddServiceState> {
  final ZodiacCachingManager _cachingManager;
  final ZodiacServicesRepository _servicesRepository;

  List<GlobalKey> localesGlobalKeys = [];
  final Map<String, List<TextEditingController>> textControllersMap = {};
  final Map<String, List<FocusNode>> focusNodesMap = {};
  final Map<String, List<ValueNotifier>> hasFocusNotifiersMap = {};
  final Map<String, List<ValidationErrorType>> errorTextsMap = {};

  bool _wasFocusRequest = false;

  AddServiceCubit(
    this._cachingManager,
    this._servicesRepository,
  ) : super(const AddServiceState()) {
    _getImages();

    emit(state.copyWith(languagesList: ['en', 'es']));

    state.languagesList?.forEach((element) {
      _setNewLocaleProperties(element, onStart: true);
    });
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
    context.push(route: const ZodiacDuplicateService());
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
            errorTextsMap[localeCode]?[index] = ValidationErrorType.empty;
            _updateTextsFlag();
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

    localesGlobalKeys.removeAt(state.languagesList?.indexOf(localeCode) ?? 0);
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
    if (value >= minDiscount && value <= maxDiscount) {
      emit(state.copyWith(discount: value));
    }
  }

  void onDiscountEnabledChanged(bool value) {
    emit(state.copyWith(discountEnabled: value));
  }

  Future<void> _getImages() async {
    // final DefaultServicesImagesResponse response =
    //     await _servicesRepository.getDefaultImages(AuthorizedRequest());

    List<String> images = List.generate(
        32,
        (index) =>
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg');

    emit(state.copyWith(images: images));
  }

  void setShowAllImages() {
    emit(state.copyWith(showAllImages: !state.showAllImages));
  }

  void selectImage(int index) {
    emit(state.copyWith(selectedImageIndex: index));
  }

  void sendForApproval() {
    final bool isChecked = _checkTextFields();
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
