import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/app_info.dart';

part 'base_request.g.dart';

@JsonSerializable(includeIfNull: false)
class BaseRequest {
  String secret = AppInfo.secret;
  String package = AppInfo.package;
  String version = '5.6'; //AppInfo.version;

  BaseRequest();

  factory BaseRequest.fromJson(Map<String, dynamic> json) =>
      _$BaseRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BaseRequestToJson(this);
}
