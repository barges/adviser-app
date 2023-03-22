// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_content.g.dart';
part 'article_content.freezed.dart';

@freezed
class ArticleContent with _$ArticleContent {
  const ArticleContent._();

  @JsonSerializable(includeIfNull: false)
  const factory ArticleContent({
    int? id,
    String? name,
    @JsonKey(name: 'date_create') int? dateCreate,
    String? description,
    String? content,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'view_type') int? viewType,
    String? img,
  }) = _ArticleContent;

  factory ArticleContent.fromJson(Map<String, dynamic> json) =>
      _$ArticleContentFromJson(json);
}
