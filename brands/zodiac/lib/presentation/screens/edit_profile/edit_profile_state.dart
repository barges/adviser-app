import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';

part 'edit_profile_state.freezed.dart';

@freezed
class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    @Default(0) int currentLocaleIndex,
    @Default(false) bool updateTextsFlag,
    DetailedUserInfo? detailedUserInfo,
    @Default([]) List<String> advisorLocales,
    @Default('') String advisorMainLocale,
    @Default([]) List<CategoryInfo> advisorCategories,
    @Default([]) List<CategoryInfo> advisorMainCategory,
    File? avatar,
  }) = _EditProfileState;
}