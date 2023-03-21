// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/models/user_info/contact_info.dart';
import 'package:zodiac/data/models/user_info/fee_info.dart';
import 'package:zodiac/data/models/user_info/personal_info.dart';
import 'package:zodiac/data/models/user_info/sign_in_info.dart';

part 'user_info.g.dart';
part 'user_info.freezed.dart';

@freezed
class UserInfo with _$UserInfo {
  const UserInfo._();

  @JsonSerializable(
      includeIfNull: false, createToJson: true, explicitToJson: true)
  const factory UserInfo({
    @JsonKey(name: 'sign_in') SignInInfo? signInInfo,
    PersonalInfo? personal,
    ContactInfo? contact,
    FeeInfo? fee,
    List<CategoryInfo>? category,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}
