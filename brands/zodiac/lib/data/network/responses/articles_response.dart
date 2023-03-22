import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/articles/article.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'articles_response.g.dart';

@JsonSerializable(includeIfNull: false)
class ArticlesResponse extends BaseResponse {
  final int? count;
  final List<Article>? result;

  const ArticlesResponse(
      {super.status, super.errorCode, super.errorMsg, this.count, this.result});

  factory ArticlesResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticlesResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ArticlesResponseToJson(this);
}
