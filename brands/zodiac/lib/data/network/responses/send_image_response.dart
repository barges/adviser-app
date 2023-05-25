import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'send_image_response.g.dart';

@JsonSerializable(includeIfNull: false)
class SendImageResponse extends BaseResponse {
  final int? count;
  final List<ChatMessageModel>? result;

  const SendImageResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.count,
    this.result,
  });

  factory SendImageResponse.fromJson(Map<String, dynamic> json) =>
      _$SendImageResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SendImageResponseToJson(this);
}
