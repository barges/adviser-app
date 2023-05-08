import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<ChatMessageModel> messages,
    @Default(false) bool isVisibleTextField,
    @Default(false) bool clientInformationWidgetOpened,
    @Default(false) bool needShowDownButton,
    @Default(false) bool needShowTypingIndicator,
    UserDetails? clientInformation,
  }) = _ChatState;
}
