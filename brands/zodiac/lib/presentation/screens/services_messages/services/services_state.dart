import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/services/service_item.dart';

part 'services_state.freezed.dart';

@freezed
class ServicesState with _$ServicesState {
  const factory ServicesState({
    List<ServiceItem>? services,
    @Default(0) int? selectedStatusIndex,
  }) = _ServicesState;
}
