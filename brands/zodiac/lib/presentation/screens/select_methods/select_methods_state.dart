import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';

part 'select_methods_state.freezed.dart';

@freezed
class SelectMethodsState with _$SelectMethodsState {
  const factory SelectMethodsState({
    List<CategoryInfo>? methods,
    @Default([]) List<int> selectedIds,
    int? mainMethodId,
  }) = _SelectMethodsState;
}
