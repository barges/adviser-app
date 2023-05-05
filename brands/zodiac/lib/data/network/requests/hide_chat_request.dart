import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'hide_chat_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class HideChatRequest extends AuthorizedRequest {
  final int chatId;

  HideChatRequest({
    required this.chatId,
  }) : super();

  factory HideChatRequest.fromJson(Map<String, dynamic> json) =>
      _$HideChatRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HideChatRequestToJson(this);
}
