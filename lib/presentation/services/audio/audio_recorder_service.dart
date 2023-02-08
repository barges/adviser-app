import 'dart:async';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart';
import 'audio_session_configure_mixin.dart';

abstract class AudioRecorderService {
  Stream<RecorderState>? get stateStream;

  Stream<RecorderDisposition>? get onProgress;

  bool get isRecording;

  Future<void> startRecorder(String fileName);

  Future<String?> stopRecorder();

  void close();
}

class AudioRecorderServiceImp extends AudioRecorderService
    with AudioSessionConfigureMixin {
  FlutterSoundRecorder? _recorder;
  StreamController<RecorderState>? _controller = StreamController.broadcast();

  AudioRecorderServiceImp() {
    _init();
  }

  Future<void> _init() async {
    await configureAudioSession();

    _recorder =
        await FlutterSoundRecorder(logLevel: Level.nothing).openRecorder();
    await _recorder?.setSubscriptionDuration(
      const Duration(seconds: 1),
    );
  }

  @override
  Stream<RecorderState>? get stateStream => _controller?.stream;

  @override
  Stream<RecorderDisposition>? get onProgress => _recorder?.onProgress
      ?.map((event) => RecorderDisposition(duration: event.duration));

  @override
  Future<void> startRecorder(String fileName) async {
    await _recorder
        ?.startRecorder(
      toFile: fileName,
      codec: Codec.aacMP4,
    )
        .then((_) {
      _controller?.add(RecorderState(_recorder?.isRecording));
    });
  }

  @override
  Future<String?> stopRecorder() async {
    return await _recorder?.stopRecorder().then((value) {
      _controller?.add(RecorderState(_recorder?.isRecording));
      return value;
    });
  }

  @override
  bool get isRecording => _recorder?.isRecording == true;

  @override
  void close() {
    _recorder?.closeRecorder();
    _recorder = null;

    _controller?.close();
    _controller = null;
  }
}

class RecorderState {
  final bool? isRecording;

  RecorderState(
    this.isRecording,
  );
}

class RecorderDisposition {
  Duration? duration;

  RecorderDisposition({
    this.duration,
  });
}
