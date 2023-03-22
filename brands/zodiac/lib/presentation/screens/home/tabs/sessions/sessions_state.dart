import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/chats/chat_item_zodiac.dart';

part 'sessions_state.freezed.dart';

@freezed
class SessionsState with _$SessionsState {
  const factory SessionsState({
    List<ZodiacChatsListItem>? chatList,
  }) = _SessionsState;
}
