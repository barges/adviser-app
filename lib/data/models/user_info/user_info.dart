import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';

part 'user_info.g.dart';

@JsonSerializable(includeIfNull: false)
class UserInfo {
  final UserStatus? status;
  final UserProfile? profile;
  @JsonKey(name: '_id')
  final String? id;

  const UserInfo({
    this.profile,
    this.status,
    this.id
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
