// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/limitation.dart';

part 'content_limitation.freezed.dart';
part 'content_limitation.g.dart';

@freezed
class ContentLimitation with _$ContentLimitation {
  @JsonSerializable(includeIfNull: false)
  const factory ContentLimitation({
    final int? min,
    final int? max,
    final Limitation? bodySize,
    final Limitation? attachments,
    final Limitation? audioTime,
  }) = _ContentLimitation;

  factory ContentLimitation.fromJson(Map<String, dynamic> json) =>
      _$ContentLimitationFromJson(json);
}
