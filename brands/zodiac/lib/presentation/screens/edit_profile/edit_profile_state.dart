import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/edit_profile/brand_model.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';

part 'edit_profile_state.freezed.dart';

@freezed
class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    @Default([]) List<int> currentLocaleIndexes,
    @Default(false) bool updateTextsFlag,
    @Default([]) List<List<String>> brandLocales,
    @Default([]) List<List<CategoryInfo>> advisorCategories,
    @Default([]) List<List<CategoryInfo>> advisorMethods,
    @Default(true) bool canRefresh,
    List<BrandModel>? brands,
    @Default(0) int selectedBrandIndex,
    @Default([]) List<File?> avatars,
  }) = _EditProfileState;
}
