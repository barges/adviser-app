import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/list_request.dart';

part 'services_list_request.g.dart';

@JsonSerializable(includeIfNull: false)
class ServiceListRequest extends ListRequest {
  ///Needs for filtering: 0 - New, 1 - Approved, 2 - Rejected, 3 - Temp
  int? status;

  ServiceListRequest({
    super.count,
    super.offset,
    this.status,
  }) : super();

  factory ServiceListRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceListRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ServiceListRequestToJson(this);
}
