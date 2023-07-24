import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/enums/chat_payment_status.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu_widget.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    List<ChatMessageModel>? messages,
    ChatMessageModel? repliedMessage,
    @Default(true) bool isVisibleTextField,
    @Default(false) bool clientInformationWidgetOpened,
    @Default(false) bool needShowDownButton,
    @Default(false) bool needShowTypingIndicator,
    @Default(false) bool chatIsActive,
    @Default(false) bool offlineSessionIsActive,
    @Default(0) int inputTextLength,
    @Default(false) bool isSendButtonEnabled,
    @Default(true) bool isTextInputCollapsed,
    @Default(18.0) double textInputHeight,
    @Default(false) bool textInputFocused,
    @Default(false) bool isStretchedTextField,
    @Default(false) bool keyboardOpened,
    @Default(false) bool isChatReconnecting,
    @Default(false) bool showOfflineSessionsMessage,
    @Default(false) bool shouldShowInput,
    @Default(false) bool isRecording,
    @Default(Duration.zero) Duration recordingDuration,
    String? reactionMessageId,
    UserDetails? clientInformation,
    Duration? chatTimerValue,
    Duration? offlineSessionTimerValue,
    ChatPaymentStatus? chatPaymentStatus,
    File? recordedAudio,
    @Default(false) bool upsellingMenuOpened,
    UpsellingMenuType? selectedUpsellingMenuItem,
  }) = _ChatState;
}
