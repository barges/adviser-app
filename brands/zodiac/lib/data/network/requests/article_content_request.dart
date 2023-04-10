import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'article_content_request.g.dart';

@JsonSerializable()
class ArticleContentRequest extends AuthorizedRequest {
  @JsonKey(name: 'article_id')
  final int articleId;

  ArticleContentRequest({required this.articleId}) : super();

  factory ArticleContentRequest.fromJson(Map<String, dynamic> json) =>
      _$ArticleContentRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ArticleContentRequestToJson(this);
}
