import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';

part 'conversations_story_response.g.dart';

@JsonSerializable()
class ConversationsStoryResponse {
  final List<ChatItem>? questions;
  final List<ChatItem>? answers;
  final String? clientID;

  const ConversationsStoryResponse({
    this.questions,
    this.answers,
    this.clientID,
  });

  factory ConversationsStoryResponse.fromJson(Map<String, dynamic> json) =>
      _$ConversationsStoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationsStoryResponseToJson(this);
}
