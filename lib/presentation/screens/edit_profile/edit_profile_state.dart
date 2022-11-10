import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_profile_state.freezed.dart';

@freezed
class EditProfileState with _$EditProfileState {
  factory EditProfileState({
    @Default([]) List<String> coverPictures,
    @Default(0) int chosenLanguageIndex,
    @Default('') String nicknameErrorText,
    @Default(false) bool nicknameHasFocus,
    @Default(true) bool updateTextsFlag,
    File? avatar,
  }) = _EditProfileState;
}
