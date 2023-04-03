import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/user_info/my_details.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'my_details_response.g.dart';

@JsonSerializable(includeIfNull: false)
class MyDetailsResponse extends BaseResponse {
  final int? count;
  final MyDetails? result;

  const MyDetailsResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.count,
    this.result,
  });

  factory MyDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$MyDetailsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MyDetailsResponseToJson(this);
}
