import 'package:shared_advisor_interface/services/audio/audio_player_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:zodiac/presentation/base_cubit/base_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/audio_players/chat_audio_player_state.dart';

class ChatAudioPlayerCubit extends BaseCubit<ChatAudioPlayerState> {
  final AudioPlayerService _player;
  final String? _url;

  ChatAudioPlayerCubit(
    this._player,
    this._url,
  ) : super(ChatAudioPlayerState(position: _player.currentPosition)) {
    final PlayerState playerState = _player.getCurrentState(_url);

    emit(state.copyWith(
      isPlaying: playerState == PlayerState.playing,
      isNotStopped: playerState != PlayerState.stopped &&
          playerState != PlayerState.completed,
    ));

    addListener(_player.stateStream.distinct().listen((event) {
      if (event.url == _url) {
        emit(state.copyWith(
          isPlaying: event.playerState == PlayerState.playing,
          isNotStopped: event.playerState != PlayerState.stopped &&
              event.playerState != PlayerState.completed,
        ));
      } else {
        emit(state.copyWith(
          isPlaying: false,
          isNotStopped: false,
          position: Duration.zero,
        ));
      }
    }));

    addListener(_player.positionStream.listen((event) {
      if (event.url == _url) {
        emit(state.copyWith(
          position: event.duration ?? Duration.zero,
        ));
      }
    }));
  }
}
