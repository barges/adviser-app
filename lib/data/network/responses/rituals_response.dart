import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/client_information.dart';
import 'package:shared_advisor_interface/data/models/chats/story.dart';

part 'rituals_response.g.dart';

@JsonSerializable()
class RitualsResponse {
  final Story? story;
  final ClientInformation? clientInformation;
  final String? clientID;

  const RitualsResponse({
    this.story,
    this.clientInformation,
    this.clientID,
  });

  factory RitualsResponse.fromJson(Map<String, dynamic> json) =>
      _$RitualsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RitualsResponseToJson(this);
}
