import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';

part 'categories_list_state.freezed.dart';

@freezed
class CategoriesListState with _$CategoriesListState {
  const factory CategoriesListState({
    List<CategoryInfo>? categories,
    @Default([]) List<int> selectedIds,
  }) = _CategoriesListState;
}
