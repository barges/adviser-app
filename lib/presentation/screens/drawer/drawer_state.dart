import 'package:freezed_annotation/freezed_annotation.dart';

part 'drawer_state.freezed.dart';

@freezed
class DrawerState with _$DrawerState {
  const factory DrawerState({
    @Default(false) bool copyButtonTapped,
    String? version,
  }) = _DrawerState;
}
