// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/brand_fields_model.dart';

part 'brand_model.g.dart';
part 'brand_model.freezed.dart';

@freezed
class BrandModel with _$BrandModel {
  const BrandModel._();

  @JsonSerializable(
    includeIfNull: false,
    createToJson: true,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory BrandModel({
    int? id,
    String? name,
    bool? isMain,
    BrandFieldsModel? fields,
    List<String>? pendingApproval,
  }) = _BrandModel;

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);
}
