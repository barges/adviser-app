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
    int? messageId,
    String? message,
    @JsonKey(fromJson: _intToBool) bool? autoreplied,
    String? time,
    String? timeFrom,
    String? timeTo,
  }) = _PrivateMessageModel;

  factory PrivateMessageModel.fromJson(Map<String, dynamic> json) =>
      _$PrivateMessageModelFromJson(json);
}

bool? _intToBool(int? value) {
  if (value != null) {
    return value == 1;
  }
  return null;
}
