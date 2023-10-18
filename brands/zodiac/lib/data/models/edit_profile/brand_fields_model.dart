// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';

part 'brand_fields_model.g.dart';
part 'brand_fields_model.freezed.dart';

@freezed
class BrandFieldsModel with _$BrandFieldsModel {
  const BrandFieldsModel._();

  @JsonSerializable(
    includeIfNull: false,
    createToJson: true,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory BrandFieldsModel({
    List<CategoryInfo>? categories,
    int? mainCategoryId,
    List<CategoryInfo>? methods,
    int? mainMethodId,
    String? avatar,
  }) = _BrandFieldsModel;

  factory BrandFieldsModel.fromJson(Map<String, dynamic> json) =>
      _$BrandFieldsModelFromJson(json);
}
