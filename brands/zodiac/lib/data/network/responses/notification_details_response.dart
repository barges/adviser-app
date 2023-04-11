import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'notification_details_response.g.dart';

@JsonSerializable(includeIfNull: false)
class NotificationDetailsResponse extends BaseResponse {
  final int? count;
  final String? result;

  const NotificationDetailsResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.count,
    this.result,
  });

  factory NotificationDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationDetailsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationDetailsResponseToJson(this);
}
