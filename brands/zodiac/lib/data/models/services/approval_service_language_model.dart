// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/services/approval_item.dart';

part 'approval_service_language_model.g.dart';
part 'approval_service_language_model.freezed.dart';

@freezed
class ApprovalServiceLanguageModel with _$ApprovalServiceLanguageModel {
  const ApprovalServiceLanguageModel._();

  @JsonSerializable(
      includeIfNull: false, fieldRename: FieldRename.snake, createToJson: true)
  const factory ApprovalServiceLanguageModel({
    @JsonKey(name: 'locale_code') String? code,
    @JsonKey(name: 'name') ApprovalItem? title,
    ApprovalItem? description,
  }) = _ApprovalServiceLanguageModel;

  factory ApprovalServiceLanguageModel.fromJson(Map<String, dynamic> json) =>
      _$ApprovalServiceLanguageModelFromJson(json);
}
