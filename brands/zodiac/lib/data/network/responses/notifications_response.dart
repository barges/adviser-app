import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/notification/notification_item.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'notifications_response.g.dart';

@JsonSerializable(includeIfNull: false)
class NotificationsResponse extends BaseResponse {
  final int? count;
  @JsonKey(name: 'unreaded_count')
  final int? unreadedCount;
  final List<NotificationItem>? result;

  const NotificationsResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.count,
    this.unreadedCount,
    this.result,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationsResponseToJson(this);
}
