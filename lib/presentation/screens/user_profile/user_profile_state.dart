import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_state.freezed.dart';

@freezed
class UserProfileState with _$UserProfileState {
  factory UserProfileState({@Default(false) bool isFavorite}) = _UserProfileState;
}
