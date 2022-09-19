import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'client_information.g.dart';

@JsonSerializable()
class ClientInformation extends Equatable {
  final String? birthdate;
  final String? zodiac;
  final String? gender;
  final String? country;

  const ClientInformation({
    this.birthdate,
    this.zodiac,
    this.gender,
    this.country,
  });

  factory ClientInformation.fromJson(Map<String, dynamic> json) =>
      _$ClientInformationFromJson(json);

  Map<String, dynamic> toJson() => _$ClientInformationToJson(this);


  @override
  List<Object?> get props => [birthdate, zodiac, gender, country];
}
