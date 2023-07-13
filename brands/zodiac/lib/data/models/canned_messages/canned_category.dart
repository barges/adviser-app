// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'canned_category.g.dart';
part 'canned_category.freezed.dart';

@freezed
class CannedCategory with _$CannedCategory {
  const CannedCategory._();

  @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
  const factory CannedCategory({
    int? id,
    String? name,
  }) = _CannedCategory;

  factory CannedCategory.fromJson(Map<String, dynamic> json) =>
      _$CannedCategoryFromJson(json);
}
