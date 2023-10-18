import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/chat/private_message_model.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'auto_reply_list_response.g.dart';

@JsonSerializable(includeIfNull: false)
class AutoReplyListResponse extends BaseResponse {
  final int? count;
  final List<PrivateMessageModel>? result;

  const AutoReplyListResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    this.count,
    this.result,
  });

  factory AutoReplyListResponse.fromJson(Map<String, dynamic> json) =>
      _$AutoReplyListResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AutoReplyListResponseToJson(this);
}
