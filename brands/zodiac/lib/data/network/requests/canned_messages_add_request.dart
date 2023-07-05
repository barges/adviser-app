import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'canned_messages_add_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class CannedMessagesAddRequest extends AuthorizedRequest {
  int? categoryId;
  String? text;

  CannedMessagesAddRequest({
    this.categoryId,
    this.text,
  }) : super();

  factory CannedMessagesAddRequest.fromJson(Map<String, dynamic> json) =>
      _$CannedMessagesAddRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CannedMessagesAddRequestToJson(this);
}
