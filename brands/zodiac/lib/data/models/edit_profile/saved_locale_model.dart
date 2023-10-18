// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_locale_model.g.dart';
part 'saved_locale_model.freezed.dart';

@freezed
class SavedLocaleModel with _$SavedLocaleModel {
  const SavedLocaleModel._();

  @JsonSerializable(
      includeIfNull: false, createToJson: true, fieldRename: FieldRename.snake)
  const factory SavedLocaleModel({
    required String localeCode,
    required String about,
    required String experience,
    required String nickname,
    required String helloMessage,
  }) = _SavedLocaleModel;

  factory SavedLocaleModel.fromJson(Map<String, dynamic> json) =>
      _$SavedLocaleModelFromJson(json);
}
