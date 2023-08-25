import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/services/service_info_item.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'get_service_info_response.g.dart';

@JsonSerializable(includeIfNull: false)
class GetServiceInfoResponse extends BaseResponse {
  @JsonKey(fromJson: _serviceFromJson)
  final ServiceInfoItem? result;

  const GetServiceInfoResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.result,
  });

  factory GetServiceInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$GetServiceInfoResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetServiceInfoResponseToJson(this);
}

ServiceInfoItem? _serviceFromJson(dynamic value) {
  if (value is Map<String, dynamic>) {
    dynamic service = value['service'];

    if (service is Map<String, dynamic>) {
      return ServiceInfoItem.fromJson(service);
    }
  }
  return null;
}
