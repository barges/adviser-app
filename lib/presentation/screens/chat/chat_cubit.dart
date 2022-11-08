import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_advisor_interface/data/models/chats/answer.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/meta.dart';
import 'package:shared_advisor_interface/data/models/chats/question.dart';
import 'package:shared_advisor_interface/data/models/chats/message.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'chat_state.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audio_session/audio_session.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatsRepository repository;
  final Question question;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _playerRecorded;
  FlutterSoundPlayer? _playerMedia;

  ChatCubit(this.repository, this.question) : super(const ChatState()) {
    _init();
    _getConversations();
  }

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

  Future<void> _init() async {
    await _initAudioSession();

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
  }

  Future<void> _initAudioSession() async {
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

  Future<void> _getConversations() async {
    ConversationsResponse conversations = await repository.getConversationsHystory(
        expertID:
            '0ba684917ad77d2b7578d7f8b54797ca92c329e80898ff0fb7ea480d32bcb090',
        clientID: question.clientID!,
        offset: 0,
        limit: 50);

    Question lastQuestion = await repository.getQuestion(id: question.id!);
    //logger.i('Question: $lastQuestion');

    final messages = List.of(state.messages);
    conversations.history!.forEach((element) {
      messages.add(
        Message<Answer>(
          element.answer!,
        ),
      );
      messages.add(
        Message<Question>(
          element.question!,
        ),
      );
    });
    messages.insert(0, Message<Question>(lastQuestion));

    emit(state.copyWith(
      messages: messages,
    ));
  }

  Future<void> startRecordingAudio() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    final fileName = 'audio_m_${Random().nextInt(10000000)}.mp4';

    await _recorder?.startRecorder(
      toFile: fileName,
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
    String? recordingPath = await _recorder?.stopRecorder();
    logger.i("recorded audio: $recordingPath");

    emit(
      state.copyWith(
        recordingPath: recordingPath!,
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
        isPlayingRecordedAudio: false,
      ),
    );
  }

  Future<void> startPlayRecordedAudio() async {
    if (_playerRecorded != null && _playerRecorded!.isPaused) {
      await _playerRecorded!.resumePlayer();
      emit(
        state.copyWith(
          isPlayingRecordedAudio: true,
        ),
      );
      return;
    }

    await _playerRecorded?.startPlayer(
      fromURI: state.recordingPath,
      codec: Codec.aacMP4,
      sampleRate: 44000,
      whenFinished: () {
        emit(
          state.copyWith(
            isPlayingRecordedAudio: false,
            playbackStream: null,
          ),
        );
      },
    );

    emit(
      state.copyWith(
        isPlayingRecordedAudio: true,
        playbackStream: _playerRecorded?.onProgress,
      ),
    );
  }

  Future<void> pauseRecordedAudio() async {
    await _playerRecorded?.pausePlayer();
    emit(
      state.copyWith(
        isPlayingRecordedAudio: false,
      ),
    );
  }

  Future<void> sendMedia() async {
    if (_playerRecorded != null && _playerRecorded!.isPlaying) {
      await _playerRecorded?.stopPlayer();
    }

    final String? mime = lookupMimeType(state.recordingPath);
    File audiofile = File(state.recordingPath);
    final List<int> audioBytes = await audiofile.readAsBytes();
    final String base64Audio = base64Encode(audioBytes);
    final Metadata meta = await MetadataRetriever.fromFile(audiofile);
    logger.i('recorded audio meta: ($mime)');
    logger.i('recorded audio meta: ($meta)');
    final request = AnswerRequest(
        questionID: question.id,
        ritualID: SessionsTypes.tarot,
        content: 'Test',
        attachments: [
          Attachment(
              mime: mime,
              attachment: base64Audio,
              meta: Meta(duration: meta.trackDuration ?? 0))
        ]);
    try {
      final Answer responseAnswer = await repository.sendAnswer(request);
      logger.i('send response:$responseAnswer');
      final messages = List.of(state.messages);
      messages.insert(0, Message<Answer>(responseAnswer));

      emit(
        state.copyWith(
          isRecordingAudio: false,
          isAudioFileSaved: false,
          isPlayingRecordedAudio: false,
          messages: messages,
        ),
      );
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> startPlayAudio(String audioUrl) async {
    if (state.audioUrl != audioUrl) {
      await _playerMedia?.stopPlayer();

      emit(
        state.copyWith(
          isPlayingAudio: false,
          isPlayingAudioFinished: true,
          audioUrl: audioUrl,
        ),
      );
    }

    if (_playerMedia != null && _playerMedia!.isPaused) {
      await _playerMedia!.resumePlayer();

      emit(
        state.copyWith(
          isPlayingAudio: true,
          isPlayingAudioFinished: false,
        ),
      );
      return;
    }

    await _playerMedia?.startPlayer(
      fromURI: audioUrl,
      codec: Codec.aacMP4,
      sampleRate: 44000,
      whenFinished: () => emit(
        state.copyWith(
          isPlayingAudio: false,
          isPlayingAudioFinished: true,
        ),
      ),
    );

    emit(
      state.copyWith(
        isPlayingAudio: true,
        isPlayingAudioFinished: false,
      ),
    );
  }

  Future<void> pauseAudio() async {
    await _playerMedia?.pausePlayer();

    emit(
      state.copyWith(
        isPlayingAudio: false,
      ),
    );
  }

  Stream<PlaybackDisposition>? get onMediaProgress => _playerMedia?.onProgress;
}
