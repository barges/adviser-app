import 'package:flutter_sound/flutter_sound.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';

part 'history_state.freezed.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState({
    @Default([]) List<ChatItem> historyMessages,
    @Default(false) bool isLoadingAudio,
    @Default(false) bool isPlayingAudio,
    @Default(true) bool isPlayingAudioFinished,
    @Default('') String audioUrl,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    Stream<PlaybackDisposition>? playbackStream,
  }) = _HistoryState;
}