import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'profile_details_response.g.dart';

@JsonSerializable(includeIfNull: false)
class ProfileDetailsResponse extends BaseResponse {
  final int? count;
  final UserDetails? result;

  const ProfileDetailsResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.count,
    this.result,
  });

  factory ProfileDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfileDetailsResponseToJson(this);
}
