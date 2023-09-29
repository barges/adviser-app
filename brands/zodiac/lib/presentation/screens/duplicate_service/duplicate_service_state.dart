import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/services/service_item.dart';

part 'duplicate_service_state.freezed.dart';

@freezed
class DuplicateServiceState with _$DuplicateServiceState {
  const factory DuplicateServiceState({
    int? selectedDuplicatedService,
    List<ServiceItem>? services,
  }) = _DuplicateServiceState;
}
