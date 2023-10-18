import 'dart:async';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'audio_session_configure_mixin.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

abstract class AudioRecorderService {
  Stream<RecorderServiceState> get stateStream;

  Stream<RecorderDisposition>? get onProgress;

  bool get isRecording;

  Future<void> startRecorder(String fileName);

  Future<String?> stopRecorder();

  Future<String?> getRecordURL({required String path});

  void close();
}

@Injectable(as: AudioRecorderService)
class AudioRecorderServiceImp extends AudioRecorderService
    with AudioSessionConfigureMixin {
  FlutterSoundRecorder? _recorder;
  final StreamController<RecorderServiceState> _controller =
      StreamController.broadcast();

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
  Stream<RecorderServiceState> get stateStream => _controller.stream;

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
      _controller.add(RecorderServiceState(
          _recorder?.recorderState.toSoundRecorderState()));
    });
  }

  @override
  Future<String?> stopRecorder() async {
    return await _recorder?.stopRecorder().then((value) {
      _controller.add(RecorderServiceState(
          _recorder?.recorderState.toSoundRecorderState()));
      return value;
    });
  }

  @override
  Future<String?> getRecordURL({required String path}) async {
    return await _recorder?.getRecordURL(path: path);
  }

  @override
  bool get isRecording => _recorder?.isRecording == true;

  @override
  void close() {
    _recorder?.closeRecorder();
    _recorder = null;

    _controller.close();
  }
}

enum SoundRecorderState {
  isStopped,
  isPaused,
  isRecording,
}

extension RecorderStateExt on RecorderState {
  SoundRecorderState toSoundRecorderState() {
    switch (this) {
      case RecorderState.isStopped:
        return SoundRecorderState.isStopped;
      case RecorderState.isPaused:
        return SoundRecorderState.isPaused;
      case RecorderState.isRecording:
        return SoundRecorderState.isRecording;
    }
  }
}

class RecorderServiceState {
  final SoundRecorderState? state;

  RecorderServiceState(
    this.state,
  );
}

class RecorderDisposition {
  Duration? duration;

  RecorderDisposition({
    this.duration,
  });
}
