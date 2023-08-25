import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'add_service_response.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class AddServiceResponse extends BaseResponse {
  final int? serviceId;

  const AddServiceResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    this.serviceId,
  });

  factory AddServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$AddServiceResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AddServiceResponseToJson(this);
}
