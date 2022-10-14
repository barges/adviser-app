import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_details_state.freezed.dart';

@freezed
class ArticleDetailsState with _$ArticleDetailsState {
  const factory ArticleDetailsState(
      [@Default(false) bool isFavorite,
      @Default(0.0) double articleReadPercentage]) = _ArticleDetailsState;
}
