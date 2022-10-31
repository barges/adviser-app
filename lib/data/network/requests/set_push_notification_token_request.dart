import 'package:json_annotation/json_annotation.dart';

part 'set_push_notification_token_request.g.dart';

@JsonSerializable(includeIfNull: false)
class SetPushNotificationTokenRequest {
  final String pushToken;
  final String? pushService;

  SetPushNotificationTokenRequest({
   required this.pushToken,
    this.pushService = 'fcm',
  });

  factory SetPushNotificationTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$SetPushNotificationTokenRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SetPushNotificationTokenRequestToJson(this);
}
