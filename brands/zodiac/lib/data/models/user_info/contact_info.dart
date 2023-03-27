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
    @JsonKey(name: 'alternative_email') String? alternativeEmail,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    int? gender,
    @JsonKey(name: 'birthday_time') String? birthdayTime,
    @JsonKey(name: 'birthday_date') String? birthdayDate,
    int? birthday,
    @JsonKey(name: 'is_subscriber') int? isSubscriber,
    String? avatar,
    @JsonKey(name: 'zodiac_sign') int? zodiacSign,
  }) = _ContactInfo;

  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoFromJson(json);
}
