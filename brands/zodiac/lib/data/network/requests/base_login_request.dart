import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/app_info.dart';
import 'package:zodiac/data/network/requests/base_request.dart';

part 'base_login_request.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class BaseLoginRequest extends BaseRequest {
  String locale = AppInfo.locale;
  @JsonKey(name: 'device_id')
  String deviceId = AppInfo.deviceId ?? '';
  String? device = AppInfo.device;
  @JsonKey(name: 'device_type')
  String deviceType = AppInfo.deviceType;
  String os = AppInfo.os;
  @JsonKey(name: 'appsflyer_id')
  String appsflyerId = AppInfo.appsflyerId;

  BaseLoginRequest();

  factory BaseLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$BaseLoginRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BaseLoginRequestToJson(this);

  @override
  String toString() {
    return 'BaseLoginRequest{locale: $locale, deviceId: $deviceId, device: $device, deviceType: $deviceType, os: $os, appsflyerId: $appsflyerId}';
  }
}
