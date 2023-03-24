import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/notification/notification_item.dart';

part 'notifications_state.freezed.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    List<NotificationItem>? notifications,
  }) = _NotificationsState;
}
