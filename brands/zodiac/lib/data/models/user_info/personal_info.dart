// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_info.g.dart';
part 'personal_info.freezed.dart';

@freezed
class PersonalInfo with _$PersonalInfo {
  const PersonalInfo._();

  @JsonSerializable(includeIfNull: false, createToJson: true)
  const factory PersonalInfo({
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    int? gender,
    @JsonKey(name: 'birthday_time') String? birthdayTime,
    @JsonKey(name: 'birthday_date') String? birthdayDate,
    int? birthday,
    @JsonKey(name: 'is_subscriber') int? isSubscriber,
    String? avatar,
    @JsonKey(name: 'zodiac_sign') int? zodiacSign,
  }) = _PersonalInfo;

  factory PersonalInfo.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoFromJson(json);
}
