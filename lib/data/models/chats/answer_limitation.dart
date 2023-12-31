// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/content_limitation.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';

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
