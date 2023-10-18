// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/chat_item_type.dart';
import 'content_limitation.dart';

part 'answer_limitation.g.dart';
part 'answer_limitation.freezed.dart';

@freezed
class AnswerLimitation with _$AnswerLimitation {
  @JsonSerializable(includeIfNull: false)
  const factory AnswerLimitation({
    final ChatItemType? questionType,
    final ContentLimitation? content,
  }) = _AnswerLimitation;

  factory AnswerLimitation.fromJson(Map<String, dynamic> json) =>
      _$AnswerLimitationFromJson(json);
}
