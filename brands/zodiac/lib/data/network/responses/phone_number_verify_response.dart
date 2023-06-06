import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'phone_number_verify_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PhoneNumberVerifyResponse extends BaseResponse {
  final bool? isVerified;

  const PhoneNumberVerifyResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.isVerified,
  });

  factory PhoneNumberVerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberVerifyResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PhoneNumberVerifyResponseToJson(this);
}
