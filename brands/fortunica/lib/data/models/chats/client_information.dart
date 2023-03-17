// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fortunica/data/models/enums/gender.dart';
import 'package:fortunica/data/models/enums/zodiac_sign.dart';

part 'client_information.freezed.dart';
part 'client_information.g.dart';

@freezed
class ClientInformation with _$ClientInformation {
  @JsonSerializable(includeIfNull: false)
  const factory ClientInformation({
    DateTime? birthdate,
    ZodiacSign? zodiac,
    @JsonKey(unknownEnumValue: Gender.unknown)
    Gender? gender,
    String? country,
  }) = _ClientInformation;

  factory ClientInformation.fromJson(Map<String, dynamic> json) =>
      _$ClientInformationFromJson(json);
}
