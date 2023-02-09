// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/user_info/contracts.dart';
import 'package:shared_advisor_interface/data/models/user_info/email_info.dart';
import 'package:shared_advisor_interface/data/models/user_info/freshchat_info.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';

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
