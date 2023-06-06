import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'phone_number_verify_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PhoneNumberVerifyRequest extends AuthorizedRequest {
  final String? captchaResponse;
  final int? code;

  PhoneNumberVerifyRequest({
    required this.captchaResponse,
    this.code,
  }) : super();

  factory PhoneNumberVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberVerifyRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PhoneNumberVerifyRequestToJson(this);
}
