// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/enums/approval_status.dart';

part 'approval_item.g.dart';
part 'approval_item.freezed.dart';

@freezed
class ApprovalItem with _$ApprovalItem {
  const ApprovalItem._();

  @JsonSerializable(
      includeIfNull: false, fieldRename: FieldRename.snake, createToJson: true)
  const factory ApprovalItem({
    @JsonKey(fromJson: ApprovalStatus.fromJson) ApprovalStatus? status,
    String? value,
  }) = _ApprovalItem;

  factory ApprovalItem.fromJson(Map<String, dynamic> json) =>
      _$ApprovalItemFromJson(json);
}
