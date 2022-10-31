import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/gender.dart';
import 'package:shared_advisor_interface/data/models/chats/zodiac_sign.dart';

part 'client_information.freezed.dart';
part 'client_information.g.dart';

@freezed
class ClientInformation with _$ClientInformation {
  @JsonSerializable(includeIfNull: false)
  const factory ClientInformation({
    DateTime? birthdate,
    ZodiacSign? zodiac,
    Gender? gender,
    String? country,
  }) = _ClientInformation;

  factory ClientInformation.fromJson(Map<String, dynamic> json) =>
      _$ClientInformationFromJson(json);
}
