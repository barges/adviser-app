import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'phone_number_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PhoneNumberRequest extends AuthorizedRequest {
  final int? phoneCode;
  final int? phoneNumber;
  final String? captchaResponse;

  PhoneNumberRequest(
      {required this.phoneCode,
      required this.phoneNumber,
      required this.captchaResponse})
      : super();

  factory PhoneNumberRequest.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PhoneNumberRequestToJson(this);
}
