import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<ChatItem> messages,
    @Default([]) List<File> attachedPictures,
    @Default(0) int inputTextLength,
    @Default(false) bool isLoadingAudio,
    @Default(false) bool isRecordingAudio,
    @Default(false) bool isAudioFileSaved,
    @Default(false) bool isPlayingRecordedAudio,
    @Default(false) bool isPlayingAudio,
    @Default(true) bool isPlayingAudioFinished,
    @Default('') String recordingPath,
    @Default('') String audioUrl,
    Stream<RecordingDisposition>? recordingStream,
    Stream<PlaybackDisposition>? playbackStream,
  }) = _ChatState;
}
