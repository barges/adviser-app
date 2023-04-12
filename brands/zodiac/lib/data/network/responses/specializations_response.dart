import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'specializations_response.g.dart';

@JsonSerializable(includeIfNull: false)
class SpecializationsResponse extends BaseResponse {
  final List<CategoryInfo>? result;

  const SpecializationsResponse({
    this.result,
  });

  factory SpecializationsResponse.fromJson(Map<String, dynamic> json) =>
      _$SpecializationsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SpecializationsResponseToJson(this);
}
