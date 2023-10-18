// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_brand_model.g.dart';
part 'saved_brand_model.freezed.dart';

@freezed
class SavedBrandModel with _$SavedBrandModel {
  const SavedBrandModel._();

  @JsonSerializable(
      includeIfNull: false, createToJson: true, fieldRename: FieldRename.snake)
  const factory SavedBrandModel({
   required int brandId,
   required List<int> categories,
   required int mainCategoryId,
   required List<int> methods,
   required int mainMethodId,
  }) = _SavedBrandModel;

  factory SavedBrandModel.fromJson(Map<String, dynamic> json) =>
      _$SavedBrandModelFromJson(json);
}
