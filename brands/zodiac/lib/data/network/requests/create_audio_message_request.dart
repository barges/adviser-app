import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/base_audio_message_request.dart';

part 'create_audio_message_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class CreateAudioMessageRequest extends BaseAudioMessageRequest {
  final String roomId;
  final int length;
  final int? repliedMessageId;

  CreateAudioMessageRequest({
    required this.roomId,
    required this.length,
    this.repliedMessageId,
  });

  factory CreateAudioMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAudioMessageRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateAudioMessageRequestToJson(this);
}
