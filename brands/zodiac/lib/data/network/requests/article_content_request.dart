import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'article_content_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ArticleContentRequest extends AuthorizedRequest {
  final int? articleId;

  ArticleContentRequest({required this.articleId}) : super();

  factory ArticleContentRequest.fromJson(Map<String, dynamic> json) =>
      _$ArticleContentRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ArticleContentRequestToJson(this);
}
