import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'get_service_info_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class GetServiceInfoRequest extends AuthorizedRequest {
  final int serviceId;

  GetServiceInfoRequest({
    required this.serviceId,
  }) : super();

  factory GetServiceInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$GetServiceInfoRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetServiceInfoRequestToJson(this);
}
