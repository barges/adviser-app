// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'canned_message_model.g.dart';

part 'canned_message_model.freezed.dart';

@freezed
class CannedMessageModel with _$CannedMessageModel {
  const CannedMessageModel._();

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
  )
  const factory CannedMessageModel({
    int? id,
    String? message,
  }) = _CannedMessageModel;

  factory CannedMessageModel.fromJson(Map<String, dynamic> json) =>
      _$CannedMessageModelFromJson(json);
}
