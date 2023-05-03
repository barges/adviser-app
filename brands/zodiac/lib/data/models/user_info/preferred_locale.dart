// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'preferred_locale.g.dart';

part 'preferred_locale.freezed.dart';

@freezed
class PreferredLocale with _$PreferredLocale {
  const PreferredLocale._();

  @JsonSerializable(
    includeIfNull: false,
    createToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory PreferredLocale({
    String? code,
    String? codeAsTitle,
    String? nameNative,
    String? flagIcon,
  }) = _PreferredLocale;

  factory PreferredLocale.fromJson(Map<String, dynamic> json) =>
      _$PreferredLocaleFromJson(json);
}
