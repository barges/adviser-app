import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    UserStatus? userStatus,
    @Default(0) int tabPositionIndex,
  }) = _HomeState;
}
