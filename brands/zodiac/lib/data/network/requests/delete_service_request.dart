import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'delete_service_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DeleteServiceRequest extends AuthorizedRequest {
  final int serviceId;

  DeleteServiceRequest({
    required this.serviceId,
  }) : super();

  factory DeleteServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteServiceRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DeleteServiceRequestToJson(this);
}
