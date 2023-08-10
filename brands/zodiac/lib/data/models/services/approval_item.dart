// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'approval_item.g.dart';
part 'approval_item.freezed.dart';

@freezed
class ApprovalItem with _$ApprovalItem {
  const ApprovalItem._();

  @JsonSerializable(
      includeIfNull: false, fieldRename: FieldRename.snake, createToJson: true)
  const factory ApprovalItem({
    int? status,
    String? value,
  }) = _ApprovalItem;

  factory ApprovalItem.fromJson(Map<String, dynamic> json) =>
      _$ApprovalItemFromJson(json);
}
