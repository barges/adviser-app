// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/review_item_zodiac.dart';

part 'reviews_list.g.dart';
part 'reviews_list.freezed.dart';

@freezed
class ReviewsList with _$ReviewsList {
  const ReviewsList._();

  @JsonSerializable(
      includeIfNull: false, explicitToJson: true)
  const factory ReviewsList({
    @JsonKey(name: 'list') List<ZodiacReviewItem>? reviewsList,
    int? count,
  }) = _ReviewsList;

  factory ReviewsList.fromJson(Map<String, dynamic> json) =>
      _$ReviewsListFromJson(json);
}
