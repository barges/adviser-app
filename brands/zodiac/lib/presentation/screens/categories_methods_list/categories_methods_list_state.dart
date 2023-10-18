import 'package:freezed_annotation/freezed_annotation.dart';

part 'categories_methods_list_state.freezed.dart';

@freezed
class CategoriesMethodsListState with _$CategoriesMethodsListState {
  const factory CategoriesMethodsListState({
    int? selectedId,
  }) = _CategoriesMethodsListState;
}
