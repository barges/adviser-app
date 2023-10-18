import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/enums/validation_error_type.dart';

part 'edit_profile_state.freezed.dart';

@freezed
class EditProfileState with _$EditProfileState {
  factory EditProfileState({
    @Default([]) List<String> coverPictures,
    @Default(0) int chosenLanguageIndex,
    @Default(false) bool nicknameHasFocus,
    @Default(true) bool updateTextsFlag,
    @Default(ValidationErrorType.empty) ValidationErrorType nicknameErrorType,
    File? avatar,
  }) = _EditProfileState;
}
