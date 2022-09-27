import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_profile_state.freezed.dart';

@freezed
class EditProfileState with _$EditProfileState {
  factory EditProfileState({
    @Default(false) bool isLoading,
    @Default([]) List<String> coverPictures,
    @Default(true) bool isWideAppBar,
    @Default(0) int chosenLanguageIndex,
    @Default('') String nicknameErrorText,
    File? avatar,
  }) = _EditProfileState;
}
