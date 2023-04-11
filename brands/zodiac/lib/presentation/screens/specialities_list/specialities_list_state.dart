import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';

part 'specialities_list_state.freezed.dart';

@freezed
class SpecialitiesListState with _$SpecialitiesListState {
  const factory SpecialitiesListState({
   @Default([]) List<CategoryInfo> categories,
    @Default([]) List<CategoryInfo> selectedCategories,
  }) = _SpecialitiesListState;
}