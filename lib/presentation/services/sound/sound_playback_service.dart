import 'dart:ui';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart';
import 'audio_session_configure_mixin.dart';

abstract class SoundPlaybackService {
  bool get isPaused;

  Stream<PlaybackDisposition>? get onProgress;

  Future<void> startPlayer({String? fromURI, VoidCallback? whenFinished});

  Future<void> pausePlayer();

  Future<void> resumePlayer();

  Future<void> stopPlayer();

  void close();
}

class SoundPlaybackServiceImp extends SoundPlaybackService
    with AudioSessionConfigureMixin {
  FlutterSoundPlayer? _player;

  SoundPlaybackServiceImp() {
    _init();
  }

  Future<void> _init() async {
    await configureAudioSession();

    _player = await FlutterSoundPlayer(logLevel: Level.nothing).openPlayer();
    await _player?.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );
  }

  @override
  bool get isPaused => _player?.isPaused == true;

  @override
  Stream<PlaybackDisposition>? get onProgress => _player?.onProgress;

  @override
  Future<void> startPlayer({
    String? fromURI,
    VoidCallback? whenFinished,
  }) async {
    await _player?.startPlayer(
      fromURI: fromURI,
      codec: Codec.aacMP4,
      sampleRate: 44000,
      whenFinished: whenFinished,
    );
  }

  @override
  Future<void> pausePlayer() async {
    if (_player?.isPlaying == true) {
      await _player?.pausePlayer();
    }
  }

  @override
  Future<void> resumePlayer() async {
    if (_player?.isPaused == true) {
      await _player!.resumePlayer();
    }
  }

  @override
  Future<void> stopPlayer() async {
    await _player?.stopPlayer();
  }

  @override
  void close() {
    _player?.closePlayer();
    _player = null;
  }
}
