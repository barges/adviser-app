import 'dart:math';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_advisor_interface/data/models/media_message.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';
import 'chat_state.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audio_session/audio_session.dart';

class ChatCubit extends Cubit<ChatState> {
  final SessionsRepository repository;
  final String? questionId;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _playerRecorded;
  FlutterSoundPlayer? _playerMedia;
  Duration? _audioDuration;
  String? _recordingPath;
  String? _mediaPath;

  ChatCubit(this.repository, this.questionId) : super(const ChatState()) {
    init();
  }

  Future<void> init() async {
    const logLevel = Level.nothing;
    _recorder = await FlutterSoundRecorder(logLevel: logLevel).openRecorder();
    _playerRecorded = await FlutterSoundPlayer(logLevel: logLevel).openPlayer();
    _playerMedia = await FlutterSoundPlayer(logLevel: logLevel).openPlayer();

    await _recorder?.setSubscriptionDuration(
      const Duration(seconds: 1),
    );

    await _playerRecorded?.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );

    await _playerMedia?.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );

    final session = await AudioSession.instance;
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

  Future<void> startRecordingAudio() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    _recordingPath ??= 'audio_m_${Random().nextInt(10000000)}.mp4';

    await _recorder?.startRecorder(
      toFile: _recordingPath,
      codec: Codec.aacMP4,
    );

    _recorder?.onProgress?.listen((e) {
      _audioDuration = e.duration;
      if (e.duration.inSeconds > 3 * 60) {
        stopRecordingAudio();
      }
    });

    emit(
      state.copyWith(
        recordingPath: _recordingPath!,
        isAudioFileSaved: false,
        isRecordingAudio: true,
        recordingStream: _recorder?.onProgress,
      ),
    );
  }

  Future<void> stopRecordingAudio() async {
    String? url = await _recorder?.stopRecorder();
    print("recorded: $url");

    emit(
      state.copyWith(
        isAudioFileSaved: true,
        isRecordingAudio: false,
      ),
    );
  }

  Future<void> cancelRecordingAudio() async {
    await _recorder?.stopRecorder();

    emit(
      state.copyWith(
        isAudioFileSaved: false,
        isRecordingAudio: false,
      ),
    );
  }

  Future<void> deletedRecordedAudio() async {
    if (_playerRecorded != null && _playerRecorded!.isPlaying) {
      await _playerRecorded?.stopPlayer();
    }

    emit(
      state.copyWith(
        isRecordingAudio: false,
        isAudioFileSaved: false,
        isPlaybackAudio: false,
      ),
    );
  }

  Future<void> startPlayRecordedAudio() async {
    if (_playerRecorded != null && _playerRecorded!.isPaused) {
      _playerRecorded!.resumePlayer();
      return;
    }

    await _playerRecorded?.startPlayer(
      fromURI: state.recordingPath,
      codec: Codec.aacMP4,
      sampleRate: 44000,
      whenFinished: () {
        emit(
          state.copyWith(
            isPlaybackAudio: false,
            playbackStream: null,
          ),
        );
      },
    );

    emit(
      state.copyWith(
        isPlaybackAudio: true,
        playbackStream: _playerRecorded?.onProgress,
      ),
    );
  }

  Future<void> pauseRecordedAudio() async {
    _playerRecorded?.pausePlayer();
  }

  void sendMedia() async {
    if (_playerRecorded != null && _playerRecorded!.isPlaying) {
      await _playerRecorded?.stopPlayer();
    }

    List<MediaMessage> messages = List<MediaMessage>.from(state.messages);
    messages.add(MediaMessage(
      audioPath: state.recordingPath,
      duration: _audioDuration,
    ));

    _recordingPath = null;

    emit(
      state.copyWith(
        isRecordingAudio: false,
        isAudioFileSaved: false,
        isPlaybackAudio: false,
        messages: messages,
      ),
    );
  }

  Future<void> startPlayAudio(
      String mediaPath, VoidCallback? whenFinished) async {
    if (_mediaPath != mediaPath) {
      _mediaPath = mediaPath;
      await _playerMedia?.stopPlayer();
    }

    if (_playerMedia != null && _playerMedia!.isPaused) {
      _playerMedia!.resumePlayer();
      return;
    }

    await _playerMedia?.startPlayer(
      fromURI: _mediaPath,
      codec: Codec.aacMP4,
      sampleRate: 44000,
      whenFinished: whenFinished,
    );
  }

  void pauseAudio() {
    _playerMedia?.pausePlayer();
  }

  Stream<PlaybackDisposition>? get onMediaProgress => _playerMedia?.onProgress;

  @override
  Future<void> close() {
    _recorder?.closeRecorder();
    _recorder = null;

    _playerRecorded?.closePlayer();
    _playerRecorded = null;

    _playerMedia?.closePlayer();
    _playerMedia = null;

    return super.close();
  }
}
