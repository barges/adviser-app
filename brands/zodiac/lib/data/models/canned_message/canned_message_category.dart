// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/canned_message/canned_message_model.dart';

part 'canned_message_category.g.dart';

part 'canned_message_category.freezed.dart';

@freezed
class CannedMessageCategory with _$CannedMessageCategory {
  const CannedMessageCategory._();

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory CannedMessageCategory({
    String? categoryName,
    List<CannedMessageModel>? messages,
  }) = _CannedMessageCategory;

  factory CannedMessageCategory.fromJson(Map<String, dynamic> json) =>
      _$CannedMessageCategoryFromJson(json);
}
