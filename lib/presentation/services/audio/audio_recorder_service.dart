import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart';
import 'audio_session_configure_mixin.dart';

abstract class AudioRecorderService {
  Stream<RecordingDisposition>? get onProgress;

  Future<void> startRecorder(String fileName);

  Future<String?> stopRecorder();

  void close();
}

class AudioRecorderServiceImp extends AudioRecorderService
    with AudioSessionConfigureMixin {
  FlutterSoundRecorder? _recorder;

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
  Stream<RecordingDisposition>? get onProgress => _recorder?.onProgress;

  @override
  Future<void> startRecorder(String fileName) async {
    await _recorder?.startRecorder(
      toFile: fileName,
      codec: Codec.aacMP4,
    );
  }

  @override
  Future<String?> stopRecorder() async {
    return await _recorder?.stopRecorder();
  }

  @override
  void close() {
    _recorder?.closeRecorder();
    _recorder = null;
  }
}
