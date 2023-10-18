import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/chats/chat_item.dart';
import '../../../data/models/enums/markets_type.dart';
import '../../../data/models/enums/zodiac_sign.dart';

part 'customer_sessions_state.freezed.dart';

@freezed
class CustomerSessionsState with _$CustomerSessionsState {
  const factory CustomerSessionsState([
    @Default([]) List<MarketsType> userMarkets,
    @Default(0) int currentMarketIndex,
    List<ChatItem>? privateQuestionsWithHistory,
    String? clientName,
    ZodiacSign? zodiacSign,
    int? currentFilterIndex,
  ]) = _CustomerSessionsState;
}
