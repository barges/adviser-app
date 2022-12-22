// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';

part 'history.freezed.dart';
part 'history.g.dart';

@freezed
class History with _$History {
  @JsonSerializable(includeIfNull: false)
  const factory History({
    @JsonKey(name: '_id') String? id,
    ChatItem? question,
    ChatItem? answer,
  }) = _History;

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);
}
