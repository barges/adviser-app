import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/canned_messages/canned_categorie.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'canned_categories_response.g.dart';

@JsonSerializable(includeIfNull: false)
class CannedCategoriesResponse extends BaseResponse {
  final List<CannedCategorie>? categories;

  const CannedCategoriesResponse(
      {super.status, super.errorCode, super.errorMsg, this.categories});

  factory CannedCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$CannedCategoriesResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CannedCategoriesResponseToJson(this);
}
