import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'article_count_request.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake,)
class ArticleCountRequest extends AuthorizedRequest {
  final int update;
  @JsonKey(name: 'is_badge')
  final int isBadge;

  ArticleCountRequest({required this.update, required this.isBadge}) : super();

  factory ArticleCountRequest.fromJson(Map<String, dynamic> json) =>
      _$ArticleCountRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ArticleCountRequestToJson(this);
}
