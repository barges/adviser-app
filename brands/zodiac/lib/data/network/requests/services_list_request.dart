import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'services_list_request.g.dart';

@JsonSerializable(includeIfNull: false)
class ServiceListRequest extends AuthorizedRequest {
  int count;
  int offset;

  ///Needs for filtering: 0 - New, 1 - Approved, 2 - Rejected, 3 - Temp
  int? status;

  ServiceListRequest({required this.count, required this.offset, this.status})
      : super();

  factory ServiceListRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceListRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ServiceListRequestToJson(this);
}
