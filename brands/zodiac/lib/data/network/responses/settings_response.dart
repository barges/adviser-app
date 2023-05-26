import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/settings/captcha.dart';
import 'package:zodiac/data/models/settings/phone.dart';
import 'package:zodiac/data/models/settings/update.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'settings_response.g.dart';

@JsonSerializable(includeIfNull: false)
class SettingsResponse extends BaseResponse {
  final Update? update;
  final int? restricted;
  final Phone? phone;
  final Captcha? captcha;

  const SettingsResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    this.update,
    this.restricted,
    this.phone,
    this.captcha,
  });

  factory SettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$SettingsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SettingsResponseToJson(this);
}
