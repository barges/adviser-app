import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'notification_details_request.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class NotificationDetailsRequest extends AuthorizedRequest {
  int pushId;

  NotificationDetailsRequest({required this.pushId}) : super();

  factory NotificationDetailsRequest.fromJson(Map<String, dynamic> json) =>
      _$NotificationDetailsRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationDetailsRequestToJson(this);
}
