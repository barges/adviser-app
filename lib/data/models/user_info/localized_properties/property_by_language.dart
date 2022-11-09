import 'package:freezed_annotation/freezed_annotation.dart';

part 'property_by_language.freezed.dart';
part 'property_by_language.g.dart';


@freezed
class PropertyByLanguage with _$PropertyByLanguage {
  @JsonSerializable(includeIfNull: false)
  const factory PropertyByLanguage({
    String? statusMessage,
    String? description,
  }) = _PropertyByLanguage;

  factory PropertyByLanguage.fromJson(Map<String, dynamic> json) =>
      _$PropertyByLanguageFromJson(json);

}
