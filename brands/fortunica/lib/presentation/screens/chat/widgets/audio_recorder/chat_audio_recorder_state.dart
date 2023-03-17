import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_audio_recorder_state.freezed.dart';

@freezed
class ChatAudioRecorderState with _$ChatAudioRecorderState {
  const factory ChatAudioRecorderState({
    @Default(false) bool isRecording,
    @Default(Duration.zero) Duration duration,
  }) = _ChatAudioRecorderState;
}
