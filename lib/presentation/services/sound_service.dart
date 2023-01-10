import 'dart:async';
import 'dart:ui';

import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart';

abstract class SoundService {
  Future<void> startRecorder(String fileName);
  Future<String?> stopRecorder();
  Future<void> startPlayerRecorded(
      {String? fromURI, VoidCallback? whenFinished});
  Future<void> pausePlayerRecorded();
  Future<void> resumePlayerRecorded();
  Future<void> stopPlayerRecorded();
  Future<void> startPlayerMedia({String? fromURI, VoidCallback? whenFinished});
  Future<void> pausePlayerMedia();
  Future<void> resumePlayerMedia();
  Future<void> stopPlayerMedia();
  void close();
  bool get playerRecordedIsPaused;
  bool get playerMediaIsPaused;
  Stream<RecordingDisposition>? get recorderOnProgress;
  Stream<PlaybackDisposition>? get playerRecordedOnProgress;
  Stream<PlaybackDisposition>? get playerMediaOnProgress;
}

class SoundServiceImp extends SoundService {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _playerRecorded;
  FlutterSoundPlayer? _playerMedia;
  final Codec _codec = Codec.aacMP4;
  final _logLevel = Level.nothing;

  SoundServiceImp() {
    _init();
  }

  Future<void> _init() async {
    await _initAudioSession();

    _recorder = await FlutterSoundRecorder(logLevel: _logLevel).openRecorder();
    _playerRecorded =
        await FlutterSoundPlayer(logLevel: _logLevel).openPlayer();
    _playerMedia = await FlutterSoundPlayer(logLevel: _logLevel).openPlayer();

    await _recorder?.setSubscriptionDuration(
      const Duration(seconds: 1),
    );

    await _playerRecorded?.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );

    await _playerMedia?.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );
  }

  Future<void> _initAudioSession() async {
    final AudioSession session = await AudioSession.instance;
    if (!session.isConfigured) {
      await session.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth |
                AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));
    }
  }

  @override
  Future<void> startRecorder(String fileName) async {
    await _recorder?.startRecorder(
      toFile: fileName,
      codec: _codec,
    );
  }

  @override
  Future<String?> stopRecorder() async {
    return await _recorder?.stopRecorder();
  }

  @override
  Future<void> startPlayerRecorded({
    String? fromURI,
    VoidCallback? whenFinished,
  }) async {
    await _playerRecorded?.startPlayer(
      fromURI: fromURI,
      codec: _codec,
      sampleRate: 44000,
      whenFinished: whenFinished,
    );
  }

  @override
  Future<void> pausePlayerRecorded() async {
    if (_playerRecorded?.isPlaying == true) {
      await _playerRecorded?.pausePlayer();
    }
  }

  @override
  Future<void> resumePlayerRecorded() async {
    if (_playerRecorded?.isPaused == true) {
      await _playerRecorded!.resumePlayer();
    }
  }

  @override
  Future<void> stopPlayerRecorded() async {
    await _playerRecorded?.stopPlayer();
  }

  @override
  Future<void> startPlayerMedia({
    String? fromURI,
    VoidCallback? whenFinished,
  }) async {
    await _playerMedia?.startPlayer(
      fromURI: fromURI,
      codec: _codec,
      sampleRate: 44000,
      whenFinished: whenFinished,
    );
  }

  @override
  Future<void> pausePlayerMedia() async {
    if (_playerMedia?.isPlaying == true) {
      await _playerMedia?.pausePlayer();
    }
  }

  @override
  Future<void> resumePlayerMedia() async {
    if (_playerMedia?.isPaused == true) {
      await _playerMedia!.resumePlayer();
    }
  }

  @override
  Future<void> stopPlayerMedia() async {
    await _playerMedia?.stopPlayer();
  }

  @override
  void close() {
    _recorder?.closeRecorder();
    _recorder = null;

    _playerRecorded?.closePlayer();
    _playerRecorded = null;

    _playerMedia?.closePlayer();
    _playerMedia = null;
  }

  @override
  bool get playerRecordedIsPaused => _playerRecorded?.isPaused == true;

  @override
  bool get playerMediaIsPaused => _playerMedia?.isPaused == true;

  @override
  Stream<RecordingDisposition>? get recorderOnProgress => _recorder?.onProgress;

  @override
  Stream<PlaybackDisposition>? get playerRecordedOnProgress =>
      _playerRecorded?.onProgress;

  @override
  Stream<PlaybackDisposition>? get playerMediaOnProgress =>
      _playerMedia?.onProgress;
}
