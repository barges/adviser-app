import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_details_state.freezed.dart';

@freezed
class NotificationDetailsState with _$NotificationDetailsState {
  const factory NotificationDetailsState({
    String? notificationContent,
    @Default(false) bool loadStopped,
  }) = _NotificationDetailsState;
}
