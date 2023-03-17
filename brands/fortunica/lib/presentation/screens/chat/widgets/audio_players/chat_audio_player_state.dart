import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_audio_player_state.freezed.dart';

@freezed
class ChatAudioPlayerState with _$ChatAudioPlayerState {
  const factory ChatAudioPlayerState({
    @Default(false) bool isPlaying,
    @Default(false) bool isNotStopped,
    @Default(Duration.zero) Duration position,
  }) = _ChatAudioPlayerState;
}