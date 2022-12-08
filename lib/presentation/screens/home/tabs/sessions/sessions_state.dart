import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';

part 'sessions_state.freezed.dart';

@freezed
class SessionsState with _$SessionsState {
  const factory SessionsState([
    @Default(false) bool searchIsOpen,
    @Default([]) List<ChatItem> conversationsList,
    @Default([]) List<ChatItem> publicQuestions,
    @Default([]) List<MarketsType> userMarkets,
    @Default([]) List<int> disabledIndexes,
    @Default(0) int currentOptionIndex,
    @Default(0) int currentFilterIndex,
    @Default(0) int currentMarketIndexForPublic,
    @Default(0) int currentMarketIndexForPrivate,
    @Default(false) bool showSuccessMessage,
  ]) = _SessionsState;
}
