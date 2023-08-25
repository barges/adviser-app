import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/services/service_item.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'services_list_response.g.dart';

@JsonSerializable(includeIfNull: false)
class ServiceListResponse extends BaseResponse {
  final int? count;
  @JsonKey(fromJson: _listFromJson)
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

List<ServiceItem>? _listFromJson(dynamic value) {
  if (value is Map<String, dynamic>) {
    List<dynamic> samples = value['list'];
    List<ServiceItem> result = [];
    for (var element in samples) {
      if (element is Map<String, dynamic>) {
        result.add(ServiceItem.fromJson(element));
      }
    }
    if (result.isNotEmpty) {
      return result;
    }
  }
  return null;
}
