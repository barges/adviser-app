// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'contracts.dart';
import 'email_info.dart';
import 'freshchat_info.dart';
import 'user_profile.dart';
import 'user_status.dart';

part 'user_info.freezed.dart';

part 'user_info.g.dart';

@freezed
class UserInfo with _$UserInfo {
  @JsonSerializable(includeIfNull: false)
  const factory UserInfo({
    Contracts? contracts,
    UserStatus? status,
    UserProfile? profile,
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'freshChat') FreshchatInfo? freshchatInfo,
    bool? pushNotificationsEnabled,
    List<EmailInfo>? emails,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}
