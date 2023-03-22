import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/user_info/user_info.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'user_info_response.g.dart';

@JsonSerializable(includeIfNull: false)
class UserInfoResponse extends BaseResponse {
  final int? count;
  final UserInfo? result;

  const UserInfoResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.count,
    this.result,
  });

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UserInfoResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserInfoResponseToJson(this);
}
