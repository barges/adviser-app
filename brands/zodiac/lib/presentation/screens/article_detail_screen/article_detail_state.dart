import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/articles/article_content.dart';

part 'article_detail_state.freezed.dart';

@freezed
class ArticlesDetailState with _$ArticlesDetailState {
  const factory ArticlesDetailState({
    ArticleContent? articleContent,
  }) = _ArticlesDetailState;
}
