import 'dart:async';

import 'package:shared_advisor_interface/services/audio/audio_player_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/presentation/screens/chat/widgets/audio_players/chat_audio_player_state.dart';

class ChatAudioPlayerCubit extends Cubit<ChatAudioPlayerState> {
  final AudioPlayerService _player;
  final String? _url;

  StreamSubscription<AudioPlayerState>? _playerStateSubscription;
  StreamSubscription<PlayerPosition>? _playerPositionSubscription;

  ChatAudioPlayerCubit(
    this._player,
    this._url,
  ) : super(const ChatAudioPlayerState()) {
    final PlayerState playerState = _player.getCurrentState(_url);

    emit(state.copyWith(
      isPlaying: playerState == PlayerState.playing,
      isNotStopped: playerState != PlayerState.stopped &&
          playerState != PlayerState.completed,
    ));

    _playerStateSubscription = _player.stateStream.distinct().listen((event) {
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
    });

    _playerPositionSubscription = _player.positionStream.listen((event) {
      if (event.url == _url) {
        emit(state.copyWith(
          position: event.duration ?? Duration.zero,
        ));
      }
    });
  }

  @override
  Future<void> close() {
    _playerStateSubscription?.cancel();
    _playerPositionSubscription?.cancel();
    return super.close();
  }
}
