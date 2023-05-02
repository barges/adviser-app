import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<ChatMessageModel> messages,
    @Default(false) bool isVisibleTextField,
}) = _ChatState;
}