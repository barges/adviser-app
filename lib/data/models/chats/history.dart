import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/answer.dart';
import 'package:shared_advisor_interface/data/models/chats/question.dart';

part 'history.freezed.dart';
part 'history.g.dart';

@freezed
class History with _$History {
  @JsonSerializable(includeIfNull: false)
  const factory History({
    Question? question,
    Answer? answer,
  }) = _History;

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);
}
