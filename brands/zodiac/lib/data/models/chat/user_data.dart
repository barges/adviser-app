// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.g.dart';

part 'user_data.freezed.dart';

@freezed
class UserData with _$UserData {
  const UserData._();

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory UserData({
    int? id,
    int? profilesId,
    String? name,
    String? avatar,
    double? fee,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
