import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'article_count_response.g.dart';

@JsonSerializable(includeIfNull: false)
class ArticleCountResponse extends BaseResponse {
  final int? count;

  const ArticleCountResponse(
      {super.status, super.errorCode, super.errorMsg, this.count});

  factory ArticleCountResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleCountResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ArticleCountResponseToJson(this);
}
