import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/models/app_success/app_success.dart';
import '../../../../../data/models/chats/chat_item.dart';
import '../../../../../data/models/enums/markets_type.dart';

part 'sessions_state.freezed.dart';

@freezed
class SessionsState with _$SessionsState {
  const factory SessionsState([
    @Default(false) bool searchIsOpen,
    @Default([]) List<MarketsType> userMarkets,
    @Default([]) List<int> disabledIndexes,
    @Default(0) int currentOptionIndex,
    @Default(0) int currentFilterIndex,
    @Default(0) int currentMarketIndexForPublic,
    @Default(0) int currentMarketIndexForPrivate,
    @Default(EmptySuccess()) AppSuccess appSuccess,
    List<ChatItem>? conversationsList,
    List<ChatItem>? publicQuestions,
  ]) = _SessionsState;
}
