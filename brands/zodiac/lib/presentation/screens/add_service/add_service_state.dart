import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/tabs_widget.dart';

part 'add_service_state.freezed.dart';

@freezed
class AddServiceState with _$AddServiceState {
  const factory AddServiceState({
    @Default(ServiceTabType.offline) ServiceTabType selectedTabIndex,
  }) = _AddServiceState;
}