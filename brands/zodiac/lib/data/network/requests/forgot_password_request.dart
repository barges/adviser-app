import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'forgot_password_request.g.dart';

@JsonSerializable(includeIfNull: false)
class ForgotPasswordRequest extends AuthorizedRequest {
  final String password;

  ForgotPasswordRequest({required this.password});

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}