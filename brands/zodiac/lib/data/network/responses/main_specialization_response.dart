import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'main_specialization_response.g.dart';

@JsonSerializable(includeIfNull: false)
class MainSpecializationResponse extends BaseResponse {
  final CategoryInfo? result;

  const MainSpecializationResponse({
    this.result,
  });

  factory MainSpecializationResponse.fromJson(Map<String, dynamic> json) =>
      _$MainSpecializationResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MainSpecializationResponseToJson(this);
}
