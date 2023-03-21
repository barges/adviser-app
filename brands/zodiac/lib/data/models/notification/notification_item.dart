// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_item.g.dart';
part 'notification_item.freezed.dart';

@freezed
class NotificationItem with _$NotificationItem {
  const NotificationItem._();

  @JsonSerializable(includeIfNull: false)
  const factory NotificationItem({
    String? type,
    @JsonKey(name: 'push_id') int? pushId,
    @JsonKey(name: 'date_create') int? dateCreate,
    String? message,
    @JsonKey(name: 'is_modal') int? isModal,
    @JsonKey(name: 'page_title') String? pageTitle,
    @JsonKey(name: 'push_open_params') String? pushOpenParams,
    @JsonKey(name: 'notify_clicks') int? notifyClicks,
    String? image,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
