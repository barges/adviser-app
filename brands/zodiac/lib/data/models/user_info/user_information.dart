// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_information.freezed.dart';

part 'user_information.g.dart';

@freezed
class UserInformation with _$UserInformation {
  @JsonSerializable(includeIfNull: false, createToJson: true)
  const factory UserInformation({
    @JsonKey(name: 'auth_token') String? authToken,
    @JsonKey(name: 'profiles_id') int? profilesId,
    int? id,
    String? name,
    String? email,
    String? locale,
    String? avatar,
    @JsonKey(name: 'session_id') String? sessionId,
  }) = _UserInformation;

  factory UserInformation.fromJson(Map<String, dynamic> json) =>
      _$UserInformationFromJson(json);
}
