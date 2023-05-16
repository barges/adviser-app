// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.g.dart';

part 'user_data.freezed.dart';

@freezed
class UserData with _$UserData {
  const UserData._();

  @JsonSerializable(
    includeIfNull: false,
    fieldRename: FieldRename.snake,
  )
  const factory UserData({
    @JsonKey(fromJson: _stringToIntFromJson) int? id,
    @JsonKey(fromJson: _stringToIntFromJson) int? profilesId,
    String? name,
    String? avatar,
    String? timezone,
    int? haveCards,
    String? helloMessage,
    @JsonKey(fromJson: _firstChatFlagFromJson) bool? firstChatFlag,
    @JsonKey(fromJson: _stringToDoubleFromJson) double? fee,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}

bool? _firstChatFlagFromJson(dynamic value) {
  if (value is bool) {
    return value;
  } else if (value is int) {
    if (value == 0) {
      return false;
    } else {
      return true;
    }
  } else {
    return null;
  }
}

int? _stringToIntFromJson(dynamic value) {
  if (value is int) {
    return value;
  } else if (value is String) {
    return int.parse(value);
  } else {
    return null;
  }
}

double? _stringToDoubleFromJson(dynamic value) {
  if (value is double) {
    return value;
  } else if (value is String) {
    return double.parse(value);
  } else {
    return null;
  }
}
