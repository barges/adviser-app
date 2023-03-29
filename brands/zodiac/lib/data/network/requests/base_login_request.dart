import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/app_info.dart';
import 'package:zodiac/data/network/requests/base_request.dart';

part 'base_login_request.g.dart';

@JsonSerializable(includeIfNull: false)
class BaseLoginRequest extends BaseRequest {
  String locale;
  @JsonKey(name: 'device_id')
  String deviceId = AppInfo.deviceId ?? '';
  String? device = AppInfo.device;
  @JsonKey(name: 'device_type')
  String deviceType = AppInfo.deviceType;
  String os = AppInfo.os;
  @JsonKey(name: 'appsflyer_id')
  String appsflyerID = AppInfo.appsflyerId;

  BaseLoginRequest({required this.locale});

  factory BaseLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$BaseLoginRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BaseLoginRequestToJson(this);
}
