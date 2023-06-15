import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'upload_audio_message_response.g.dart';

@JsonSerializable(includeIfNull: false)
class UploadAudioMessageResponse extends BaseResponse {
  final ChatMessageModel? result;

  const UploadAudioMessageResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    this.result,
  });

  factory UploadAudioMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadAudioMessageResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UploadAudioMessageResponseToJson(this);
}
