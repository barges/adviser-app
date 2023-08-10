// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'canned_message_socket_model.g.dart';

part 'canned_message_socket_model.freezed.dart';

@freezed
class CannedMessageSocketModel with _$CannedMessageSocketModel {
  const CannedMessageSocketModel._();

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
  )
  const factory CannedMessageSocketModel({
    int? id,
    String? message,
  }) = _CannedMessageSocketModel;

  factory CannedMessageSocketModel.fromJson(Map<String, dynamic> json) =>
      _$CannedMessageSocketModelFromJson(json);
}
