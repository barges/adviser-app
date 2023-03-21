// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'article.g.dart';
part 'article.freezed.dart';

@freezed
class Article with _$Article {
  const Article._();

  @JsonSerializable(includeIfNull: false)
  const factory Article({
    int? id,
    @JsonKey(fromJson: _nameFromJson) String? name,
    @JsonKey(name: 'date_create') int? dateCreate,
    String? description,
    @JsonKey(name: 'category_id') int? categoryId,
    @Default(false)
    @JsonKey(name: 'is_read', fromJson: _isReadFromJson)
        bool isRead,
    String? img,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}

String? _nameFromJson(dynamic jsonValue) {
  return jsonValue is double ? jsonValue.toString() : jsonValue;
}

bool _isReadFromJson(int? jsonValue) {
  return jsonValue == null || jsonValue == 0 ? false : true;
}
