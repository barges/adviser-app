// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/brand_locale_model.dart';
import 'package:zodiac/data/models/user_info/brand_model.dart';
import 'package:zodiac/data/models/user_info/locale_descriptions.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';

part 'brand_and_locales_model.g.dart';
part 'brand_and_locales_model.freezed.dart';

@freezed
class BrandAndLocalesModel with _$BrandAndLocalesModel {
  const BrandAndLocalesModel._();

  @JsonSerializable(
    includeIfNull: false,
    createToJson: true,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory BrandAndLocalesModel({
    BrandModel? brand,
    List<BrandLocaleModel>? locales,
  }) = _BrandAndLocalesModel;

  factory BrandAndLocalesModel.fromJson(Map<String, dynamic> json) =>
      _$BrandAndLocalesModelFromJson(json);
}
