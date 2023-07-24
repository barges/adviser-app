import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/delivery_time_slider_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/tabs_widget.dart';

part 'add_service_state.freezed.dart';

@freezed
class AddServiceState with _$AddServiceState {
  const factory AddServiceState({
    @Default(ServiceTabType.offline) ServiceTabType selectedTabIndex,
    @Default(0) int selectedLanguageIndex,
    int? mainLanguageIndex,
    List<String>? languagesList,
    @Default(10.99) double price,
    @Default(DeliveryTimeTabType.minutes)
    DeliveryTimeTabType selectedDeliveryTimeTab,
    @Default(20) double deliveryTime,
    @Default(10) double discount,
    @Default(false) bool discountEnabled,
    @Default(0) int selectedImageIndex,
    List<String>? images,
    @Default(false) bool showAllImages,
    @Default(false) bool updateTextsFlag,
  }) = _AddServiceState;
}
