// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'locale_model.g.dart';

part 'locale_model.freezed.dart';

@freezed
class LocaleModel with _$LocaleModel {
  const LocaleModel._();

  @JsonSerializable(
    includeIfNull: false,
    fieldRename: FieldRename.snake,
  )
  const factory LocaleModel({
    String? code,
    String? nameEn,
    String? nameNative,
    String? defaultFlag,
    String? translated,
  }) = _LocaleModel;

  factory LocaleModel.fromJson(Map<String, dynamic> json) =>
      _$LocaleModelFromJson(json);
}
