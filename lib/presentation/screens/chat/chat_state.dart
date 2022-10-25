import 'package:freezed_annotation/freezed_annotation.dart';
part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default(false) bool isLoadingAudio,
    @Default(false) bool isRecordingAudio,
    @Default(false) bool isAudioFileSaved,
    @Default('audio_file.mp4') String recordingPath,
  }) = _ChatState;
}
