import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/review_item_zodiac.dart';

part 'reviews_state.freezed.dart';

@freezed
class ReviewsState with _$ReviewsState {
  const factory ReviewsState({
    List<ZodiacReviewItem>? reviewList,
  }) = _ReviewsState;
}
