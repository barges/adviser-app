// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_item_zodiac.g.dart';

part 'review_item_zodiac.freezed.dart';

@freezed
class ZodiacReviewItem with _$ZodiacReviewItem {
  const ZodiacReviewItem._();

  @JsonSerializable(
    includeIfNull: false,
    createToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory ZodiacReviewItem({
    String? id,
    String? chatId,
    int? dateCreate,
    String? text,
    int? rating,
    String? fakeName,
    String? avatar,
  }) = _ZodiacReviewItem;

  factory ZodiacReviewItem.fromJson(Map<String, dynamic> json) =>
      _$ZodiacReviewItemFromJson(json);
}
