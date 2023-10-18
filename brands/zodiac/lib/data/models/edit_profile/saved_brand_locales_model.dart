// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/edit_profile/saved_brand_model.dart';
import 'package:zodiac/data/models/edit_profile/saved_locale_model.dart';

part 'saved_brand_locales_model.g.dart';
part 'saved_brand_locales_model.freezed.dart';

@freezed
class SavedBrandLocalesModel with _$SavedBrandLocalesModel {
  const SavedBrandLocalesModel._();

  @JsonSerializable(includeIfNull: false, createToJson: true)
  const factory SavedBrandLocalesModel({
    required SavedBrandModel brand,
    required List<SavedLocaleModel> locales,
  }) = _SavedBrandLocalesModel;

  factory SavedBrandLocalesModel.fromJson(Map<String, dynamic> json) =>
      _$SavedBrandLocalesModelFromJson(json);
}
