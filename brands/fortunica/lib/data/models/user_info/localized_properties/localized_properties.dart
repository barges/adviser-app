import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fortunica/data/models/user_info/localized_properties/property_by_language.dart';

part 'localized_properties.g.dart';

@JsonSerializable(includeIfNull: false)
class LocalizedProperties extends Equatable {
  final PropertyByLanguage? de;
  final PropertyByLanguage? en;
  final PropertyByLanguage? es;
  final PropertyByLanguage? pt;

  const LocalizedProperties({
    this.de,
    this.en,
    this.es,
    this.pt,
  });

  factory LocalizedProperties.fromJson(Map<String, dynamic> json) =>
      _$LocalizedPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$LocalizedPropertiesToJson(this);

  @override
  List<Object?> get props => [de, en, es, pt];
}
