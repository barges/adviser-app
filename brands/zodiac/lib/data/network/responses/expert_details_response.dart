import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'expert_details_response.g.dart';

@JsonSerializable(includeIfNull: false)
class ExpertDetailsResponse extends BaseResponse {
  final int? count;
  final DetailedUserInfo? result;
  final List<String>? locales;

  const ExpertDetailsResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.count,
    this.result,
    this.locales,
  });

  factory ExpertDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$ExpertDetailsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ExpertDetailsResponseToJson(this);
}
