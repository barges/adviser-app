import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/app_info.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';

part 'base_audio_message_request.g.dart';

@JsonSerializable(includeIfNull: false)
class BaseAudioMessageRequest {
  String secret = AppInfo.secret;
  String? auth = zodiacGetIt.get<ZodiacCachingManager>().getUserToken();

  BaseAudioMessageRequest();

  factory BaseAudioMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$BaseAudioMessageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BaseAudioMessageRequestToJson(this);
}
