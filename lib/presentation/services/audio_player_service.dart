import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../../main.dart';

abstract class AudioPlayerService {
  Stream<AudioPlayerState> get stateStream;

  Stream<PlayerPosition> get positionStream;

  void playPause(Uri uri);

  void stop();

  void seek(String url, Duration duration);

  PlayerState getCurrentState(String? url);

  void dispose();
}

class AudioPlayerServiceImpl implements AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  PlayerState _state = PlayerState.stopped;

  String? _currentUrl;

  StreamSubscription? _stateSubscription;

  AudioPlayerServiceImpl() {
    _stateSubscription = _player.onPlayerStateChanged.listen((event) {
      logger.d(event);
      _state = event;
    });
  }

  @override
  void playPause(Uri uri) {
    final String url = uri.toString();
    final Source source =
        uri.hasScheme ? UrlSource(url) : DeviceFileSource(url);
    if (_state == PlayerState.stopped || _state == PlayerState.completed) {
      _player.play(source);
      _currentUrl = url;
    } else {
      if (_state == PlayerState.playing) {
        if (url != _currentUrl) {
          _player.stop();
          _player.play(source);
          _currentUrl = url;
        } else {
          _player.pause();
        }
      } else if (_state == PlayerState.paused) {
        if (url != _currentUrl) {
          _player.stop();
          _player.play(source);
          _currentUrl = url;
        } else {
          _player.resume();
        }
      }
    }
  }

  @override
  void stop() {
    if (_state == PlayerState.playing || _state == PlayerState.paused) {
      _player.stop();
    }
  }

  @override
  void dispose() {
    stop();
    _stateSubscription?.cancel();
    _player.dispose();
  }

  @override
  Stream<AudioPlayerState> get stateStream => _player.onPlayerStateChanged
      .map((event) => AudioPlayerState(playerState: event, url: _currentUrl));

  @override
  PlayerState getCurrentState(String? url) {
    if (url == _currentUrl) {
      return _state;
    } else {
      return PlayerState.stopped;
    }
  }

  @override
  Stream<PlayerPosition> get positionStream => _player.onPositionChanged
      .map((event) => PlayerPosition(duration: event, url: _currentUrl));

  @override
  void seek(String url, Duration duration) {
    if (url == _currentUrl &&
        (_state == PlayerState.playing || _state == PlayerState.paused)) {
      _player.seek(duration);
    }
  }
}

class AudioPlayerState {
  final PlayerState? playerState;
  final String? url;

  AudioPlayerState({
    this.playerState,
    this.url,
  });
}

class PlayerPosition {
  final Duration? duration;
  final String? url;

  PlayerPosition({
    this.duration,
    this.url,
  });
}
