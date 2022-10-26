import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';
import 'chat_state.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audio_session/audio_session.dart';

class ChatCubit extends Cubit<ChatState> {
  final SessionsRepository _repository;
  final String? questionId;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;

  ChatCubit(this._repository, this.questionId) : super(const ChatState()) {
    init();
  }

  Future<void> init() async {
    _recorder = await FlutterSoundRecorder().openRecorder();
    _player = await FlutterSoundPlayer().openPlayer();

    await _recorder?.setSubscriptionDuration(
      const Duration(seconds: 1),
    );

    await _player?.setSubscriptionDuration(
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

    await _recorder?.startRecorder(
      toFile: state.recordingPath,
      codec: Codec.aacMP4,
    );
    _recorder?.onProgress?.listen((e) {
      if (e.duration.inSeconds > 3 * 60) {
        stopRecordingAudio();
      }
    });

    emit(
      state.copyWith(
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
    if (_player != null && !_player!.isPlaying) {
      await _player?.stopPlayer();
    }

    emit(
      state.copyWith(
        isRecordingAudio: false,
        isAudioFileSaved: false,
        isPlaybackAudio: false,
      ),
    );
  }

  Future<void> startPlayAudio() async {
    if (_player != null && _player!.isPaused) {
      _player!.resumePlayer();
      return;
    }

    await _player?.startPlayer(
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

    emit(state.copyWith(
      isPlaybackAudio: true,
      playbackStream: _player?.onProgress,
    ));
  }

  Future<void> pausePlayAudio() async {
    _player?.pausePlayer();
  }

  @override
  Future<void> close() {
    _recorder?.closeRecorder();
    _recorder = null;

    _player?.closePlayer();
    _player = null;

    return super.close();
  }
}
