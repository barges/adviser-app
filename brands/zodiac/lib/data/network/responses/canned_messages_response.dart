import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/canned_messages/canned_message.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'canned_messages_response.g.dart';

@JsonSerializable(includeIfNull: false)
class CannedMessagesResponse extends BaseResponse {
  final List<CannedMessage>? messages;

  const CannedMessagesResponse(
      {super.status, super.errorCode, super.errorMsg, this.messages});

  factory CannedMessagesResponse.fromJson(Map<String, dynamic> json) =>
      _$CannedMessagesResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CannedMessagesResponseToJson(this);
}
