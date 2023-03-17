import 'package:fortunica/data/models/user_info/user_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    UserStatus? userStatus,
    @Default(0) int tabPositionIndex,
  }) = _HomeState;
}
