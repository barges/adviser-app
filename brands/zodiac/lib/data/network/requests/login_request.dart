import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/base_login_request.dart';

part 'login_request.g.dart';

@JsonSerializable(includeIfNull: false)
class LoginRequest extends BaseLoginRequest {
  final String password;
  final String email;

  LoginRequest(
      {required this.email, required this.password, required super.locale});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
