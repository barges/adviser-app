import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/chat/entity.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'create_audio_message_response.g.dart';

@JsonSerializable(includeIfNull: false)
class CreateAudioMessageResponse extends BaseResponse {
  final Entity? result;

  const CreateAudioMessageResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    this.result,
  });

  factory CreateAudioMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateAudioMessageResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateAudioMessageResponseToJson(this);
}
