// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/answer_limitation.dart';

part 'answer_validation_response.g.dart';
part 'answer_validation_response.freezed.dart';

@freezed
class AnswerValidationResponse with _$AnswerValidationResponse {
  @JsonSerializable(includeIfNull: false)
  const factory AnswerValidationResponse({
    @JsonKey(name: 'data') final List<AnswerLimitation>? answerLimitations,
  }) = _AnswerValidationResponse;

  factory AnswerValidationResponse.fromJson(Map<String, dynamic> json) =>
      _$AnswerValidationResponseFromJson(json);
}
