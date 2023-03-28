// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_info.g.dart';

part 'personal_info.freezed.dart';

@freezed
class PersonalInfo with _$PersonalInfo {
  const PersonalInfo._();

  @JsonSerializable(
    includeIfNull: false,
    createToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory PersonalInfo({
    String? firstName,
    String? lastName,
    int? gender,
    String? birthdayTime,
    String? birthdayDate,
    int? birthday,
    int? isSubscriber,
    String? avatar,
    int? zodiacSign,
  }) = _PersonalInfo;

  factory PersonalInfo.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoFromJson(json);
}
