import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'canned_messages_delete_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class CannedMessagesDeleteRequest extends AuthorizedRequest {
  int? messageId;

  CannedMessagesDeleteRequest({
    this.messageId,
  }) : super();

  factory CannedMessagesDeleteRequest.fromJson(Map<String, dynamic> json) =>
      _$CannedMessagesDeleteRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CannedMessagesDeleteRequestToJson(this);
}
