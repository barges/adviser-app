import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'canned_messages_update_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class CannedMessagesUpdateRequest extends AuthorizedRequest {
  int? messageId;
  int? categoryId;
  String? text;

  CannedMessagesUpdateRequest({
    this.messageId,
    this.categoryId,
    this.text,
  }) : super();

  factory CannedMessagesUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$CannedMessagesUpdateRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CannedMessagesUpdateRequestToJson(this);
}
