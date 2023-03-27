import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/articles/article_content.dart';

part 'article_details_state.freezed.dart';

@freezed
class ArticleDetailsState with _$ArticleDetailsState {
  const factory ArticleDetailsState({
    ArticleContent? articleContent,
  }) = _ArticleDetailsState;
}
