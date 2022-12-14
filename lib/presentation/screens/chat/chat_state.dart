import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/data/models/app_errors/empty_error.dart';
import 'package:shared_advisor_interface/data/models/app_success/app_success.dart';
import 'package:shared_advisor_interface/data/models/app_success/empty_success.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<ChatItem> activeMessages,
    @Default([]) List<ChatItem> hystoryMessages,
    @Default([]) List<File> attachedPictures,
    @Default(0) int currentTabIndex,
    @Default(0) int inputTextLength,
    @Default(false) bool isLoadingAudio,
    @Default(false) bool isRecordingAudio,
    @Default(false) bool isAudioFileSaved,
    @Default(false) bool isPlayingRecordedAudio,
    @Default(false) bool isPlayingAudio,
    @Default(true) bool isPlayingAudioFinished,
    @Default(true) bool showInputFieldIfPublic,
    @Default(false) bool isSendButtonEnabled,
    @Default(true) bool isMicrophoneButtonEnabled,
    @Default('') String audioUrl,
    @Default(EmptyError()) AppError appError,
    @Default(EmptySuccess()) AppSuccess appSuccess,
    String? recordingPath,
    Stream<RecordingDisposition>? recordingStream,
    Stream<PlaybackDisposition>? playbackStream,
    ChatItem? questionFromDB,
    ChatItemStatusType? questionStatus,
    FlutterSoundPlayer? flutterSoundPlayer,
    String? clientName,
    ZodiacSign? zodiacSign,
  }) = _ChatState;
}
