import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/articles/article.dart';

part 'articles_state.freezed.dart';

@freezed
class ArticlesState with _$ArticlesState {
  const factory ArticlesState({
    List<Article>? articleList,
  }) = _ArticlesState;
}
