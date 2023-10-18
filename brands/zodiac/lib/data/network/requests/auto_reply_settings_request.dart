import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'auto_reply_settings_request.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class AutoReplySettingsRequest extends AuthorizedRequest {
  final int? saveForm;
  @JsonKey(toJson: _boolToInt)
  final bool? autoreplied;
  final int? messageId;
  final String? time;
  final String? timeFrom;
  final String? timeTo;

  AutoReplySettingsRequest({
    this.saveForm,
    this.autoreplied,
    this.messageId,
    this.time,
    this.timeFrom,
    this.timeTo,
  }) : super();

  factory AutoReplySettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$AutoReplySettingsRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AutoReplySettingsRequestToJson(this);
}

int? _boolToInt(bool? value) {
  if (value != null) {
    return value ? 1 : 0;
  }
  return null;
}
