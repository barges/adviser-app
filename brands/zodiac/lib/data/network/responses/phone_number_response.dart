import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'phone_number_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PhoneNumberResponse extends BaseResponse {
  final bool? needVerification;

  const PhoneNumberResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.needVerification,
  });

  factory PhoneNumberResponse.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PhoneNumberResponseToJson(this);
}
