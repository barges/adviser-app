import 'package:flutter_sound/flutter_sound.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/media_message.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default(false) bool isLoadingAudio,
    @Default(false) bool isRecordingAudio,
    @Default(false) bool isAudioFileSaved,
    @Default(false) bool isPlaybackAudio,
    @Default([]) List<MediaMessage> messages,
    @Default('audio_m.mp4') String recordingPath,
    Stream<RecordingDisposition>? recordingStream,
    Stream<PlaybackDisposition>? playbackStream,
  }) = _ChatState;
}
