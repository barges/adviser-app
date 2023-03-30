import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';

part 'edit_profile_state.freezed.dart';

@freezed
class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    DetailedUserInfo? detailedUserInfo,
  }) = _EditProfileState;
}