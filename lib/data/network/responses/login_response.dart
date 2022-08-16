import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable(includeIfNull: false)
class LoginResponse {
  final String? accessToken;


  LoginResponse(this.accessToken);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}