// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_item_zodiac.g.dart';
part 'review_item_zodiac.freezed.dart';

@freezed
class ZodiacReviewItem with _$ZodiacReviewItem {
  const ZodiacReviewItem._();

  @JsonSerializable(includeIfNull: false, createToJson: true)
  const factory ZodiacReviewItem({
    String? id,
    @JsonKey(name: 'chat_id') String? chatId,
    @JsonKey(name: 'date_create') int? dateCreate,
    String? text,
    int? rating,
    @JsonKey(name: 'fake_name') String? fakeName,
    String? avatar,
  }) = _ZodiacReviewItem;

  factory ZodiacReviewItem.fromJson(Map<String, dynamic> json) =>
      _$ZodiacReviewItemFromJson(json);
}
