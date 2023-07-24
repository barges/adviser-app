import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'canned_messages_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class CannedMessagesRequest extends AuthorizedRequest {
  int? categoryId;
  int? messageId;
  String? text;

  CannedMessagesRequest({
    this.categoryId,
    this.messageId,
    this.text,
  }) : super();

  factory CannedMessagesRequest.fromJson(Map<String, dynamic> json) =>
      _$CannedMessagesRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CannedMessagesRequestToJson(this);
}
