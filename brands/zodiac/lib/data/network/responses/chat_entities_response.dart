import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/chats/chat_item_zodiac.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'chat_entities_response.g.dart';

@JsonSerializable(includeIfNull: false)
class ChatEntitiesResponse extends BaseResponse {
  final String? count;
  final List<ZodiacChatsListItem>? result;
  @JsonKey(name: 'hidden_chats')
  final List<int>? hiddenChats;

  const ChatEntitiesResponse(
      {super.status,
      super.errorCode,
      super.errorMsg,
      super.message,
      this.count,
      this.result,
      this.hiddenChats});

  factory ChatEntitiesResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatEntitiesResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChatEntitiesResponseToJson(this);
}
