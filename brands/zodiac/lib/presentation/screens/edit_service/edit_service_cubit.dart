import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/data/models/services/service_info_item.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/get_service_info_request.dart';
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

  EditServiceCubit({
    required this.serviceId,
    required this.servicesRepository,
    required this.zodiacCachingManager,
  }) : super(const EditServiceState()) {
    fetchData();
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
          _setupLanguageTexts(element.code!, element.title?.value ?? '',
              element.description?.value ?? '');
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
      String localeCode, String title, String description) {
    textControllersMap[localeCode]?[ZodiacConstants.serviceTitleIndex].text =
        title;
    textControllersMap[localeCode]?[ZodiacConstants.serviceDescriptionIndex]
        .text = description;
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
}
