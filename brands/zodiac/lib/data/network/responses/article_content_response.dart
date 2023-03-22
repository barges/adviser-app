import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/articles/article_content.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'article_content_response.g.dart';

@JsonSerializable(includeIfNull: false)
class ArticleContentResponse extends BaseResponse {
  final int? count;
  final ArticleContent? result;

  const ArticleContentResponse(
      {super.status, super.errorCode, super.errorMsg, this.count, this.result});

  factory ArticleContentResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleContentResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ArticleContentResponseToJson(this);
}
