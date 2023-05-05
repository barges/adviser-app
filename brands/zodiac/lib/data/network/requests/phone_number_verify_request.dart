import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'phone_number_verify_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PhoneNumberVerifyRequest extends AuthorizedRequest {
  final int? code;
  final String? captchaResponse;

  PhoneNumberVerifyRequest({
    required this.code,
    required this.captchaResponse,
  }) : super();

  factory PhoneNumberVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberVerifyRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PhoneNumberVerifyRequestToJson(this);
}
