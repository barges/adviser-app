import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/chat/private_message_model.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'auto_reply_settings_response.g.dart';

@JsonSerializable(includeIfNull: false)
class AutoReplySettingsResponse extends BaseResponse {
  final int? count;
  final PrivateMessageModel? result;

  const AutoReplySettingsResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    this.count,
    this.result,
  });

  factory AutoReplySettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$AutoReplySettingsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AutoReplySettingsResponseToJson(this);
}
