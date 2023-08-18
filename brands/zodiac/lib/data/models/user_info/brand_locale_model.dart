// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/locale_descriptions.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';

part 'brand_locale_model.g.dart';
part 'brand_locale_model.freezed.dart';

@freezed
class BrandLocaleModel with _$BrandLocaleModel {
  const BrandLocaleModel._();

  @JsonSerializable(
    includeIfNull: false,
    createToJson: true,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory BrandLocaleModel({
    LocaleModel? locale,
    LocaleDescriptions? fields,
    List<String>? pendingApproval,
  }) = _BrandLocaleModel;

  factory BrandLocaleModel.fromJson(Map<String, dynamic> json) =>
      _$BrandLocaleModelFromJson(json);
}
