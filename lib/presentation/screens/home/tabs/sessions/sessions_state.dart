import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';

part 'sessions_state.freezed.dart';

@freezed
class SessionsState with _$SessionsState {
  const factory SessionsState([
    @Default(false) bool searchIsOpen,
    @Default([]) List<ChatItem> privateQuestionsWithHistory,
    @Default([]) List<ChatItem> publicQuestions,
    @Default([]) List<MarketsType> userMarkets,
    @Default(0) int currentOptionIndex,
    @Default(0) int currentFilterIndex,
    @Default(0) int currentMarketIndexForPublic,
    @Default(0) int currentMarketIndexForPrivate,
  ]) = _SessionsState;
}
