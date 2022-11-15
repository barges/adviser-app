import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/chats/meta.dart';
import 'package:shared_advisor_interface/data/models/enums/file_ext.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_type.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'chat_state.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audio_session/audio_session.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatsRepository repository;
  final ChatItem question;
  final ScrollController messagesScrollController = ScrollController();
  final ScrollController textInputScrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  final MainCubit _mainCubit = Get.find<MainCubit>();
  final Codec _codec = CurrentCodec.current;
  final FileExt _recordFileExt = CurrentFileExt.current;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _playerRecorded;
  FlutterSoundPlayer? _playerMedia;
  int offset = 0;
  int limit = AppConstants.itemsPerLoadChatHistory;
  int? total;

  ChatCubit(this.repository, this.question) : super(const ChatState()) {
    _init();
    _getConversations();
  }

  @override
  Future<void> close() {
    messagesScrollController.dispose();
    textInputScrollController.dispose();
    textEditingController.dispose();

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

    messagesScrollController.addListener(scrollControllerListener);
    textEditingController.addListener(textEditingControllerListener);
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

  void scrollControllerListener() {
    if (!_mainCubit.state.isLoading &&
        messagesScrollController.position.extentAfter <= 300) {
      _getConversations();
    }
  }

  void textEditingControllerListener() {
    emit(state.copyWith(
      inputTextLength: textEditingController.text.length,
    ));
  }

  Future<void> _getConversations() async {
    if (total != null) {
      if (offset == total! || limit > total!) {
        return;
      }
      if (offset + limit > total!) {
        limit = total! - offset;
      }
    }

    ConversationsResponse conversations = await repository.getConversationsHystory(
        expertID:
            '0ba684917ad77d2b7578d7f8b54797ca92c329e80898ff0fb7ea480d32bcb090',
        clientID: question.clientID!,
        offset: offset,
        limit: limit);

    ChatItem? lastQuestion;
    if (total == null) {
      lastQuestion = await repository.getQuestion(id: question.id!);
      //logger.i('Question: $lastQuestion');
    }

    total = conversations.total;
    offset = offset + limit;

    final messages = List.of(state.messages);
    conversations.history!.forEach((element) {
      messages.add(
        element.answer!.copyWith(
          isAnswer: true,
          type: element.question!.type,
          ritualIdentifier: element.question!.ritualIdentifier,
        ),
      );
      messages.add(
        element.question!,
      );
    });
    if (lastQuestion != null) {
      messages.insert(0, lastQuestion);
    }

    emit(state.copyWith(
      messages: messages,
    ));
  }

  Future<void> startRecordingAudio() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    final fileName = '${AppConstants.recordFileName}.${_recordFileExt.name}';

    await _recorder?.startRecorder(
      toFile: fileName,
      codec: _codec,
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
      codec: _codec,
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
      codec: _codec,
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

  void attachPicture(File? image) {
    final images = List.of(state.attachedPics);
    if (_mainCubit.state.internetConnectionIsAvailable &&
        images.length < 2 &&
        image != null) {
      images.add(image);
      emit(state.copyWith(attachedPics: images));
    }
  }

  void deletePicture(File? image) {
    final images = List.of(state.attachedPics);
    images.remove(image);
    emit(state.copyWith(attachedPics: images));
  }

  void deleteAttachedPics() {
    for (var image in state.attachedPics) {
      deletePicture(image);
    }
  }

  Future<void> sendMedia() async {
    if (_playerRecorded != null && _playerRecorded!.isPlaying) {
      await _playerRecorded?.stopPlayer();
    }

    final Attachment audioAttachment = await _getAudioAttachment();
    Attachment? pictureAttachment;
    if (state.attachedPics.isNotEmpty) {
      pictureAttachment = await _getPictureAttachment(0);
    }

    final request = AnswerRequest(
      questionID: '5fddd475bd7774001cf0b029',
      ritualID: SessionsTypes.tarot, //messages[0].ritualIdentifier,/
      attachments: [
        audioAttachment,
        if (pictureAttachment != null) pictureAttachment,
      ],
    );

    try {
      final ChatItem responseAnswer = await repository.sendAnswer(request);
      logger.i('send media response:$responseAnswer');
      final messages = List.of(state.messages);
      messages.insert(0, responseAnswer.copyWith(isAnswer: true));

      emit(
        state.copyWith(
          isRecordingAudio: false,
          isAudioFileSaved: false,
          isPlayingRecordedAudio: false,
          messages: messages,
        ),
      );

      deleteAttachedPics();
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> sendTextMedia() async {
    Attachment? pictureAttachment1 =
        state.attachedPics.length == 1 ? await _getPictureAttachment(0) : null;
    Attachment? pictureAttachment2 =
        state.attachedPics.length == 2 ? await _getPictureAttachment(1) : null;

    final request = AnswerRequest(
      questionID: '5fddcfa7bd7774001cf0b009',
      ritualID: SessionsTypes.tarot,
      content: textEditingController.text.isEmpty
          ? null
          : textEditingController.text,
      attachments: [
        if (pictureAttachment1 != null) pictureAttachment1,
        if (pictureAttachment2 != null) pictureAttachment2,
      ],
    );

    try {
      final ChatItem responseAnswer = await repository.sendAnswer(request);
      logger.i('send text response:$responseAnswer');

      textEditingController.clear();

      final messages = List.of(state.messages);
      messages.insert(0, responseAnswer.copyWith(isAnswer: true));

      emit(
        state.copyWith(
          messages: messages,
        ),
      );

      deleteAttachedPics();
    } catch (e) {
      logger.e(e);
    }
  }

  Future<Attachment> _getAudioAttachment() async {
    final File audiofile = File(state.recordingPath);
    final List<int> audioBytes = await audiofile.readAsBytes();
    final String base64Audio = base64Encode(audioBytes);
    final Metadata metaAudio = await MetadataRetriever.fromFile(audiofile);

    return Attachment(
        mime: lookupMimeType(state.recordingPath),
        attachment: base64Audio,
        meta: Meta(duration: (metaAudio.trackDuration ?? 0) / 1000));
  }

  Future<Attachment> _getPictureAttachment(int n) async {
    final File imageFile = state.attachedPics[n];
    final List<int> imageBytes = await imageFile.readAsBytes();
    final String base64Image = base64Encode(imageBytes);
    return Attachment(
      mime: lookupMimeType(imageFile.path),
      attachment: base64Image,
    );
  }

  Stream<PlaybackDisposition>? get onMediaProgress => _playerMedia?.onProgress;
}
