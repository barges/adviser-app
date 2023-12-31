import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/app_success/app_success.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/chats/rirual_card_info.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default([])
        List<ChatItem> activeMessages,
    @Default([])
        List<File> attachedPictures,
    @Default(0)
        int currentTabIndex,
    @Default(0)
        int inputTextLength,
    @Default(true)
        bool showInputFieldIfPublic,
    @Default(false)
        bool isSendButtonEnabled,
    @Default(EmptySuccess())
        AppSuccess appSuccess,
    @Default(false)
        bool isAudioAnswerEnabled,
    @Default(false)
        bool refreshEnabled,
    RitualCardInfo? ritualCardInfo,
    File? recordedAudio,
    ChatItem? questionFromDB,
    ChatItemStatusType? questionStatus,
    @Default(
      CustomerProfileScreenArguments(
        clientName: '',
      ),
    )
        CustomerProfileScreenArguments? appBarUpdateArguments,
    @Default(true)
        bool isTextInputCollapsed,
    @Default(18.0)
        double textInputHeight,
    @Default(false)
        bool textInputFocused,
    @Default(false)
        bool isStretchedTextField,
    @Default(96.0)
        double bottomTextAreaHeight,
  }) = _ChatState;
}
