import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
 class BaseResponse {
  final bool? status;
  @JsonKey(name: 'error_code')
  int? errorCode;
  @JsonKey(name: 'error_msg')
  final String? errorMsg;

  BaseResponse({this.status, this.errorCode, this.errorMsg});

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}
