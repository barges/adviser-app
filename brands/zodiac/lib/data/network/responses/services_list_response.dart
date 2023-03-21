import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/services/service_item.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'services_list_response.g.dart';

@JsonSerializable(includeIfNull: false)
class ServiceListResponse extends BaseResponse {
  final int? count;
  final List<ServiceItem>? result;

  const ServiceListResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.count,
    this.result,
  });

  factory ServiceListResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceListResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ServiceListResponseToJson(this);
}
