import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/services/service_list_result.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'services_response.g.dart';

@JsonSerializable(includeIfNull: false)
class ServiceResponse extends BaseResponse {
  final ServiceListResult? result;

  const ServiceResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    this.result,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ServiceResponseToJson(this);
}
