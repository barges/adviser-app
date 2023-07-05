import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'canned_messages_add_response.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class CannedMessagesAddResponse extends BaseResponse {
  final int? messageId;

  const CannedMessagesAddResponse(
      {super.status, super.errorCode, super.errorMsg, this.messageId});

  factory CannedMessagesAddResponse.fromJson(Map<String, dynamic> json) =>
      _$CannedMessagesAddResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CannedMessagesAddResponseToJson(this);
}
