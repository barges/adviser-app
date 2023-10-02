import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';

part 'select_categories_state.freezed.dart';

@freezed
class SelectCategoriesState with _$SelectCategoriesState {
  const factory SelectCategoriesState({
    List<CategoryInfo>? categories,
    @Default([]) List<int> selectedIds,
    int? mainCategoryId,
  }) = _SelectCategoriesState;
}
