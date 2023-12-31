import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/audio_recorder/chat_audio_recorder_state.dart';
import 'package:shared_advisor_interface/presentation/services/audio/audio_recorder_service.dart';

class ChatAudioRecorderCubit extends Cubit<ChatAudioRecorderState> {
  final AudioRecorderService _recorder;
  StreamSubscription<RecorderDisposition>? _recordingProgressSubscription;
  StreamSubscription<RecorderServiceState>? _recordingStateSubscription;

  ChatAudioRecorderCubit(
    this._recorder,
  ) : super(const ChatAudioRecorderState()) {
    _recordingStateSubscription = _recorder.stateStream?.listen((e) async {
      if (e.state == SoundRecorderState.isRecording) {
        emit(state.copyWith(
          duration: const Duration(),
        ));

        _recordingProgressSubscription =
            _recorder.onProgress?.listen((e) async {
          emit(state.copyWith(
            duration: e.duration ?? const Duration(),
          ));
        });
      } else {
        _recordingProgressSubscription?.cancel();
      }

      emit(state.copyWith(
        isRecording: e.state == SoundRecorderState.isRecording,
      ));
    });
  }

  @override
  Future<void> close() {
    _recordingProgressSubscription?.cancel();
    _recordingStateSubscription?.cancel();

    return super.close();
  }
}
