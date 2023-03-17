// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_information.freezed.dart';

part 'user_information.g.dart';

@freezed
class UserInformation with _$UserInformation {
  @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
  const factory UserInformation({
    String? authToken,
    int? profilesId,
    int? id,
    String? name,
    String? email,
    String? locale,
    String? avatar,
    String? sessionId,
  }) = _UserInformation;

  factory UserInformation.fromJson(Map<String, dynamic> json) =>
      _$UserInformationFromJson(json);
}
