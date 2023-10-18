import 'package:json_annotation/json_annotation.dart';

import '../../models/chats/history.dart';

part 'history_response.g.dart';

@JsonSerializable(includeIfNull: false)
class HistoryResponse {
  @JsonKey(name: 'data')
  final List<History>? history;
  final bool? hasMore;
  final String? lastItem;
  final bool? hasBefore;
  final String? firstItem;

  const HistoryResponse({
    this.history,
    this.hasMore,
    this.lastItem,
    this.hasBefore,
    this.firstItem,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryResponseToJson(this);
}
