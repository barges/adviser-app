import 'package:json_annotation/json_annotation.dart';
import 'package:fortunica/data/models/chats/history.dart';

part 'conversations_response.g.dart';

@JsonSerializable()
class ConversationsResponse {
  final List<History>? history;
  final int? total;
  final int? offset;
  final int? limit;

  const ConversationsResponse(
      {this.history, this.total, this.offset, this.limit});

  factory ConversationsResponse.fromJson(Map<String, dynamic> json) =>
      _$ConversationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationsResponseToJson(this);
}
