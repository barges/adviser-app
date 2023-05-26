// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_based.g.dart';
part 'score_based.freezed.dart';

@freezed
class ScoreBased with _$ScoreBased {
  const ScoreBased._();

  @JsonSerializable(includeIfNull: false)
  const factory ScoreBased({
    String? key,
  }) = _ScoreBased;

  factory ScoreBased.fromJson(Map<String, dynamic> json) =>
      _$ScoreBasedFromJson(json);
}
