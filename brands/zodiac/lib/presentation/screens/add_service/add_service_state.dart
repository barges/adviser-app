import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/enums/service_type.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/delivery_time_slider_widget.dart';

part 'add_service_state.freezed.dart';

@freezed
class AddServiceState with _$AddServiceState {
  const factory AddServiceState({
    @Default(ServiceType.offline) ServiceType selectedTab,
    @Default(0) int selectedLanguageIndex,
    int? mainLanguageIndex,
    @Default(['en']) List<String> languagesList,
    @Default(10.99) double price,
    @Default(DeliveryTimeTabType.minutes)
    DeliveryTimeTabType selectedDeliveryTimeTab,
    @Default(20) double deliveryTime,
    @Default(10) double discount,
    @Default(false) bool discountEnabled,
    @Default(0) int selectedImageIndex,
    List<ImageSampleModel>? images,
    @Default(false) bool showAllImages,
    @Default(false) bool updateTextsFlag,
    String? duplicatedServiceName,
    @Default(false) bool updateAfterDuplicate,
    @Default(false) bool alreadyTriedToGetImages,
  }) = _AddServiceState;
}
