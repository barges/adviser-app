import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/main.dart';

part 'base_response.g.dart';

@JsonSerializable(includeIfNull: false)
class BaseResponse {
  final bool? status;
  @JsonKey(name: 'error_code')
  final int? errorCode;
  @JsonKey(name: 'error_msg')
  final String? errorMsg;
  final String? message;

  const BaseResponse({
    this.status,
    this.errorCode,
    this.errorMsg,
    this.message,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);

  String getErrorMessage() {
    return message?.isNotEmpty == true
        ? message!
        : errorMsg?.isNotEmpty == true
            ? errorMsg!
            : 'Unlnown error';
  }
}
