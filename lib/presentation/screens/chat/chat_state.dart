import 'package:flutter_sound/flutter_sound.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default(false) bool isLoadingAudio,
    @Default(false) bool isRecordingAudio,
    @Default(false) bool isAudioFileSaved,
    @Default(false) bool isPlayingRecordedAudio,
    @Default(false) bool isPlayingAudio,
    @Default(true) bool isPlayingAudioFinished,
    @Default([]) List<ChatItem> messages,
    @Default('') String recordingPath,
    @Default('') String audioUrl,
    Stream<RecordingDisposition>? recordingStream,
    Stream<PlaybackDisposition>? playbackStream,
  }) = _ChatState;
}
