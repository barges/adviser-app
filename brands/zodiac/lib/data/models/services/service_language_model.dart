// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_language_model.g.dart';
part 'service_language_model.freezed.dart';

@freezed
class ServiceLanguageModel with _$ServiceLanguageModel {
  const ServiceLanguageModel._();

  @JsonSerializable(
      includeIfNull: false, fieldRename: FieldRename.snake, createToJson: true)
  const factory ServiceLanguageModel({
    @JsonKey(name: 'locale_code') String? code,
    @JsonKey(name: 'name') String? title,
    String? description,
  }) = _ServiceLanguageModel;

  factory ServiceLanguageModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceLanguageModelFromJson(json);
}