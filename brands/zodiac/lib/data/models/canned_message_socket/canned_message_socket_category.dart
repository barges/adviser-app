// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/canned_message_socket/canned_message_socket_model.dart';

part 'canned_message_socket_category.g.dart';

part 'canned_message_socket_category.freezed.dart';

@freezed
class CannedMessageSocketCategory with _$CannedMessageSocketCategory {
  const CannedMessageSocketCategory._();

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory CannedMessageSocketCategory({
    String? categoryName,
    List<CannedMessageSocketModel>? messages,
  }) = _CannedMessageSocketCategory;

  factory CannedMessageSocketCategory.fromJson(Map<String, dynamic> json) =>
      _$CannedMessageSocketCategoryFromJson(json);
}
