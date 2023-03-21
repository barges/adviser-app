import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/base_request.dart';

part 'forgot_password_request.g.dart';

@JsonSerializable(includeIfNull: false)
class ForgotPasswordRequest extends BaseRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}
