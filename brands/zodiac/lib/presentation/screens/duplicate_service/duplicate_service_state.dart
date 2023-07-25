import 'package:freezed_annotation/freezed_annotation.dart';

part 'duplicate_service_state.freezed.dart';

@freezed
class DuplicateServiceState with _$DuplicateServiceState {
  const factory DuplicateServiceState({
    int? selectedDuplicatedService,
    @Default([]) List<String> services,
  }) = _DuplicateServiceState;
}
