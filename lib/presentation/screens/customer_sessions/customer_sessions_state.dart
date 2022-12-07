import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/customer_info/customer_info.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';

part 'customer_sessions_state.freezed.dart';

@freezed
class CustomerSessionsState with _$CustomerSessionsState {
  const factory CustomerSessionsState([
    @Default([]) List<ChatItem> sessionsQuestions,
    @Default(0) int currentFilterIndex,
    String? clientName,
    ZodiacSign? zodiacSign,
  ]) = _CustomerSessionsState;
}
