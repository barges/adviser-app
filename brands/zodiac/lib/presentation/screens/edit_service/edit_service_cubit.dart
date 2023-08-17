import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/approval_status.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/data/models/services/service_info_item.dart';
import 'package:zodiac/data/models/services/service_language_model.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/edit_service_request.dart';
import 'package:zodiac/data/network/requests/get_service_info_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/default_services_images_response.dart';
import 'package:zodiac/data/network/responses/get_service_info_response.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/delivery_time_slider_widget.dart';
import 'package:zodiac/presentation/screens/edit_service/edit_service_state.dart';
import 'package:zodiac/zodiac_constants.dart';

const int _textFieldsCount = 2;

class EditServiceCubit extends Cubit<EditServiceState> {
  final int serviceId;
  final ZodiacServicesRepository servicesRepository;
  final ZodiacCachingManager zodiacCachingManager;

  List<GlobalKey> languagesGlobalKeys = [];
  final Map<String, List<TextEditingController>> textControllersMap = {};
  final Map<String, List<FocusNode>> focusNodesMap = {};
  final Map<String, List<ValueNotifier>> hasFocusNotifiersMap = {};
  final Map<String, List<ValidationErrorType>> errorTextsMap = {};
  final Map<String, List<ApprovalStatus?>> approvalStatusMap = {};

  bool _wasFocusRequest = false;

  EditServiceCubit({
    required this.serviceId,
    required this.servicesRepository,
    required this.zodiacCachingManager,
  }) : super(const EditServiceState()) {
    fetchData();
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

  Future<void> fetchData() async {
    try {
      await _getImages();
      await _getServiceInfo();
    } catch (e) {
      logger.d(e);
    } finally {
      emit(state.copyWith(
        alreadyFetchData: true,
        dataFetched: state.languagesList != null && state.images != null,
      ));
    }
  }

  Future<void> _getImages() async {
    final DefaultServicesImagesResponse response =
        await servicesRepository.getDefaultImages(AuthorizedRequest());

    if (response.status == true) {
      List<ImageSampleModel>? images = response.samples;

      emit(state.copyWith(images: images));
    }
  }

  Future<void> _getServiceInfo() async {
    final GetServiceInfoResponse response = await servicesRepository
        .getServiceInfo(GetServiceInfoRequest(serviceId: serviceId));

    if (response.status == true) {
      final ServiceInfoItem? serviceInfo = response.result;

      final List<String> _newLanguagesList = [];
      serviceInfo?.translations?.forEach((element) {
        if (element.code != null) {
          _newLanguagesList.add(element.code!);
          _setLocaleProperties(element.code!);
          _setupLanguageTexts(
              element.code!, element.title ?? '', element.description ?? '');
        }
      });

      serviceInfo?.approval?.forEach((element) {
        if (element.code != null) {
          _newLanguagesList.add(element.code!);
          _setLocaleProperties(element.code!);
          _setupLanguageTexts(
            element.code!,
            element.title?.value ?? '',
            element.description?.value ?? '',
            approvalStatusTitle: element.title?.status,
            approvalStatusDescription: element.description?.status,
          );
        }
      });

      EditServiceState newState =
          state.copyWith(languagesList: _newLanguagesList);

      if (serviceInfo?.mainLocale != null) {
        final int mainLanguageIndex =
            _newLanguagesList.indexOf(serviceInfo!.mainLocale!);
        newState = newState.copyWith(mainLanguageIndex: mainLanguageIndex);
      }

      if (serviceInfo?.imageAlias != null) {
        final int? selectedImageIndex = state.images?.indexWhere(
            (element) => element.imageAlias == serviceInfo?.imageAlias);

        if (selectedImageIndex != null) {
          newState = newState.copyWith(selectedImageIndex: selectedImageIndex);
        }
      }

      if (serviceInfo?.price != null) {
        newState = newState.copyWith(price: serviceInfo!.price!);
      }

      if (serviceInfo?.duration != null) {
        DeliveryTimeTabType? deliveryTimeTabType =
            DeliveryTimeTabType.fromSeconds(serviceInfo?.duration);

        newState = newState.copyWith(
          deliveryTimeType: deliveryTimeTabType ?? DeliveryTimeTabType.minutes,
          deliveryTime: deliveryTimeTabType
                  ?.deliveryTimeFromSeconds(serviceInfo?.duration) ??
              20,
        );
      }

      emit(newState);
    }
  }

  void _setLocaleProperties(String localeCode) {
    errorTextsMap[localeCode] = List<ValidationErrorType>.generate(
      _textFieldsCount,
      (index) => ValidationErrorType.empty,
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

    approvalStatusMap[localeCode] =
        List.generate(_textFieldsCount, (index) => null);

    languagesGlobalKeys.add(GlobalKey());
  }

  void _updateTextsFlag() {
    bool flag = state.updateTextsFlag;
    emit(state.copyWith(updateTextsFlag: !flag));
  }

  void changeLocaleIndex(int newIndex) {
    emit(state.copyWith(selectedLanguageIndex: newIndex));
    Utils.animateToWidget(languagesGlobalKeys[newIndex]);
  }

  String localeNativeName(String code) {
    List<LocaleModel>? locales = zodiacCachingManager.getAllLocales();

    return locales
            ?.firstWhere((element) => element.code == code,
                orElse: () => const LocaleModel())
            .nameNative ??
        '';
  }

  void _setupLanguageTexts(
    String localeCode,
    String title,
    String description, {
    ApprovalStatus? approvalStatusTitle,
    ApprovalStatus? approvalStatusDescription,
  }) {
    textControllersMap[localeCode]?[ZodiacConstants.serviceTitleIndex].text =
        title;
    textControllersMap[localeCode]?[ZodiacConstants.serviceDescriptionIndex]
        .text = description;

    approvalStatusMap[localeCode]?[ZodiacConstants.serviceTitleIndex] =
        approvalStatusTitle;
    approvalStatusMap[localeCode]?[ZodiacConstants.serviceDescriptionIndex] =
        approvalStatusDescription;
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

  void setShowAllImages() {
    emit(state.copyWith(showAllImages: !state.showAllImages));
  }

  void selectImage(int index) {
    emit(state.copyWith(selectedImageIndex: index));
  }

  Future<void> sendForApproval(BuildContext context) async {
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
      final EditServiceRequest request = EditServiceRequest(
        imageAlias: images[state.selectedImageIndex].imageAlias ?? '',
        translations: translations,
        serviceId: serviceId,
        duration: state.deliveryTimeType.toSeconds(state.deliveryTime.toInt()),
      );

      BaseResponse response = await servicesRepository.editService(request);

      if (response.status == true) {
        // ignore: use_build_context_synchronously
        context.pop();
      }
    } else {
      _updateTextsFlag();
    }
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
