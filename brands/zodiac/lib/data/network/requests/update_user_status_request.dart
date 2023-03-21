import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'update_user_status_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateUserStatusRequest extends AuthorizedRequest {
  final int status;

  UpdateUserStatusRequest({required this.status});

  factory UpdateUserStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserStatusRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UpdateUserStatusRequestToJson(this);
}
