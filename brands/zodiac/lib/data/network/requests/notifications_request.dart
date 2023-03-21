import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'notifications_request.g.dart';

@JsonSerializable()
class NotificationsRequest extends AuthorizedRequest {
  final int count;
  final int offset;

  NotificationsRequest({
    required this.count,
    required this.offset,
  }) : super();

  factory NotificationsRequest.fromJson(Map<String, dynamic> json) =>
      _$NotificationsRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationsRequestToJson(this);
}
