import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'chat_entities_request.g.dart';

@JsonSerializable(includeIfNull: false)
class ChatEntitiesRequest extends AuthorizedRequest {
  int count;
  int offset;

  ChatEntitiesRequest({required this.count, required this.offset}) : super();

  factory ChatEntitiesRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatEntitiesRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChatEntitiesRequestToJson(this);
}
