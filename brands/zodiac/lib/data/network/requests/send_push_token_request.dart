import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/app_info.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'send_push_token_request.g.dart';

@JsonSerializable()
class SendPushTokenRequest extends AuthorizedRequest {
  @JsonKey(name: 'registration_id')
  final String registrationId;
  @JsonKey(name: 'device_type')
  String deviceType = AppInfo.deviceType;

  SendPushTokenRequest({
    required this.registrationId,
  }) : super();

  factory SendPushTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$SendPushTokenRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SendPushTokenRequestToJson(this);
}
