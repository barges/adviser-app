import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/app_info.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'settings_request.g.dart';

@JsonSerializable(includeIfNull: false)
class SettingsRequest extends AuthorizedRequest {
  @JsonKey(name: 'device_type')
  final String deviceType = AppInfo.deviceType;

  SettingsRequest();

  factory SettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$SettingsRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SettingsRequestToJson(this);
}
