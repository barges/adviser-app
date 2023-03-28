// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_info.g.dart';
part 'contact_info.freezed.dart';

@freezed
class ContactInfo with _$ContactInfo {
  const ContactInfo._();

  @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
  const factory ContactInfo({
    String? street,
    String? city,
    dynamic zipCode, //Может прийти int или String
    int? country,
    String? countryName,
    @JsonKey(name: 'country_code2') String? countryCode,
    String? state,
    dynamic phone, //Может прийти int или String
    String? alternativeEmail,
    String? firstName,
    String? lastName,
    int? gender,
    String? birthdayTime,
    String? birthdayDate,
    int? birthday,
    int? isSubscriber,
    String? avatar,
    int? zodiacSign,
  }) = _ContactInfo;

  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoFromJson(json);
}
