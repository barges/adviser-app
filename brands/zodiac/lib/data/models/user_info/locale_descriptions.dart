
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'locale_descriptions.g.dart';

part 'locale_descriptions.freezed.dart';

@freezed
class LocaleDescriptions with _$LocaleDescriptions {
  const LocaleDescriptions._();

  @JsonSerializable(
    includeIfNull: false,
    fieldRename: FieldRename.snake,
  )
  const factory LocaleDescriptions({
    dynamic nickname,
    dynamic shortDescr,
    dynamic about,
    dynamic experience,
    dynamic helloMessage,
    dynamic avatar,
  }) = _LocaleDescriptions;

  factory LocaleDescriptions.fromJson(Map<String, dynamic> json) =>
      _$LocaleDescriptionsFromJson(json);
}