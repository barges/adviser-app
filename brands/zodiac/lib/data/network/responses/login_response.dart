import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/user_info/user_information.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'login_response.g.dart';

@JsonSerializable(includeIfNull: false)
class LoginResponse extends BaseResponse {
  final int? count;
  final UserInformation? result;

  const LoginResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.count,
    this.result,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
