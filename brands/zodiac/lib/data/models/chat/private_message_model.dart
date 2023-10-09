// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'private_message_model.g.dart';

part 'private_message_model.freezed.dart';

@freezed
class PrivateMessageModel with _$PrivateMessageModel {
  const PrivateMessageModel._();

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory PrivateMessageModel({
    int? id,
    String? message,
  }) = _PrivateMessageModel;

  factory PrivateMessageModel.fromJson(Map<String, dynamic> json) =>
      _$PrivateMessageModelFromJson(json);
}
