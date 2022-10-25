import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'property_by_language.g.dart';

@JsonSerializable()
class PropertyByLanguage extends Equatable {
  final String? statusMessage;
  final String? description;

  const PropertyByLanguage({
    this.statusMessage,
    this.description,
  });

  factory PropertyByLanguage.fromJson(Map<String, dynamic> json) =>
      _$PropertyByLanguageFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyByLanguageToJson(this);

  @override
  List<Object?> get props => [statusMessage, description];
}
