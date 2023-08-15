import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/enums/service_type.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/delivery_time_slider_widget.dart';

part 'edit_service_state.freezed.dart';

@freezed
class EditServiceState with _$EditServiceState {
  const factory EditServiceState(
      {@Default(false) bool alreadyFetchData,
      List<ImageSampleModel>? images,
      @Default(false) bool updateTextsFlag,
      @Default(0) int selectedLanguageIndex,
      int? mainLanguageIndex,
      List<String>? languagesList,
      @Default(10.99) double price,
      @Default(10) double discount,
      @Default(false) bool discountEnabled,
      @Default(0) int selectedImageIndex,
      @Default(false) bool showAllImages,
      @Default(false) bool dataFetched,
      @Default(ServiceType.offline) ServiceType serviceType,
      @Default(20) double deliveryTime,
      @Default(DeliveryTimeTabType.minutes)
      DeliveryTimeTabType deliveryTimeType}) = _EditServiceState;
}
