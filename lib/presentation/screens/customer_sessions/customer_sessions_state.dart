import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';

part 'customer_sessions_state.freezed.dart';

@freezed
class CustomerSessionsState with _$CustomerSessionsState {
  const factory CustomerSessionsState([
    @Default(0) int currentFilterIndex,
    List<ChatItem>? sessionsQuestions,
    String? clientName,
    ZodiacSign? zodiacSign,
  ]) = _CustomerSessionsState;
}
