// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_language_model.g.dart';
part 'service_language_model.freezed.dart';

@freezed
class ServiceLanguageModel with _$ServiceLanguageModel {
  const ServiceLanguageModel._();

  @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
  const factory ServiceLanguageModel({
    String? code,
    String? title,
    @Default(false) bool isMain,
  }) = _ServiceLanguageModel;

  factory ServiceLanguageModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceLanguageModelFromJson(json);
}
