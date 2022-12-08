import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/chats/meta.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/data/models/enums/file_ext.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs_types.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'chat_state.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audio_session/audio_session.dart';

class ChatCubit extends Cubit<ChatState> {
  final ScrollController activeMessagesScrollController = ScrollController();
  final ScrollController historyMessagesScrollController = ScrollController();
  final ScrollController textInputScrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  final CachingManager _cachingManager;
  final ChatsRepository _repository;
  late final ChatItem? questionFromArguments;
  final BuildContext _context;
  final MainCubit _mainCubit = getIt.get<MainCubit>();
  final Codec _codec = Codec.aacMP4;
  final FileExtantion _recordFileExt = CurrentFileExt.current;
  final int _tillShowMessagesInSec = 25 * 60;
  final int _afterShowMessagesInSec = 5 * 60;
  final int _limit = 25;
  int _offset = 0;
  int? _total;
  num? _recordAudioDuration;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _playerRecorded;
  FlutterSoundPlayer? _playerMedia;
  AnswerRequest? _answerRequest;
  StreamSubscription<RecordingDisposition>? _recordingProgressSubscription;
  Timer? _answerTimer;
  DateTime? _takenDate;
  bool _counterMessageCleared = false;

  ChatCubit(
    this._cachingManager,
    this._repository,
    this._context,
  ) : super(const ChatState()) {
    questionFromArguments = Get.arguments;
    _init();
    _getData().whenComplete(_checkTiming);
    _setQuestionStatus(
        questionFromArguments?.status ?? ChatItemStatusType.open);
  }

  @override
  Future<void> close() {
    activeMessagesScrollController.dispose();
    historyMessagesScrollController.dispose();

    textInputScrollController.dispose();
    textEditingController.dispose();

    _recorder?.closeRecorder();
    _recorder = null;

    _playerRecorded?.closePlayer();
    _playerRecorded = null;

    _playerMedia?.closePlayer();
    _playerMedia = null;

    _recordingProgressSubscription?.cancel();
    _recordingProgressSubscription = null;

    _answerTimer?.cancel();
    _answerTimer = null;

    _answerRequest = null;

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

    //activeMessagesScrollController.addListener(scrollControllerListener);
    historyMessagesScrollController.addListener(scrollControllerListener);

    textEditingController.addListener(textEditingControllerListener);
  }

  Future<void> _getData() async {
    if (await _getQuestion()) {
      _getConversations();
    }
  }

  _setQuestionStatus(ChatItemStatusType status) {
    emit(
      state.copyWith(
        questionStatus: status,
      ),
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

  void scrollControllerListener() {
    if (!_mainCubit.state.isLoading &&
        historyMessagesScrollController.position.extentAfter <= 300) {
      _getConversations();
    }
  }

  void textEditingControllerListener() {
    final textLength = textEditingController.text.length;
    emit(
      state.copyWith(
        inputTextLength: textEditingController.text.length,
        isSendButtonEnabled:
            textLength >= minTextLength && textLength <= maxTextLength,
      ),
    );
  }

  Future<void> _getConversations() async {
    if (_total != null && _offset >= _total!) {
      return;
    }

    ConversationsResponse conversations =
        await _repository.getConversationsHystory(
            expertID: _cachingManager.getUserId() ?? '',
            clientID: questionFromArguments?.clientID ?? '',
            offset: _offset,
            limit: _limit);

    _total = conversations.total;
    _offset = _offset + _limit;

    final messages = List.of(state.hystoryMessages);
    for (var element in conversations.history ?? []) {
      messages.add(
        element.answer?.copyWith(
          isAnswer: true,
          type: element.question?.type,
          ritualIdentifier: element.question?.ritualIdentifier,
        ),
      );
      messages.add(
        element.question,
      );
    }

    emit(state.copyWith(
      hystoryMessages: messages,
    ));
  }

  Future<void> takeQuestion() async {
    try {
      final ChatItem question = await _repository
          .takeQuestion(AnswerRequest(questionID: questionFromArguments?.id));
      _setQuestionStatus(question.status ?? ChatItemStatusType.open);
      _mainCubit.updateSessions();
      if (question.status == ChatItemStatusType.taken) {
        _startTimer(_tillShowMessagesInSec, _afterShowMessagesInSec);
      }
    } on DioError catch (e) {
      await showOkCancelAlert(
        context: _context,
        title: _mainCubit.state.errorMessage,
        okText: S.of(_context).ok,
        actionOnOK: () {
          Get.offNamed(AppRoutes.home,
              arguments: HomeScreenArguments(initTab: TabsTypes.sessions));
        },
        allowBarrierClock: false,
        isCancelEnabled: false,
      );
      logger.d(e);
    }
  }

  Future<void> returnQuestion() async {
    try {
      final ChatItem question = await _repository
          .returnQuestion(AnswerRequest(questionID: questionFromArguments?.id));
      _setQuestionStatus(question.status ?? ChatItemStatusType.open);
      _mainCubit.updateSessions();

      _answerTimer?.cancel();
      _answerTimer = null;
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> startRecordingAudio() async {
    if (await Permission.microphone.isPermanentlyDenied) {
      openAppSettings();
    } else {
      await Permission.microphone.request();
    }

    final isRecordGranted = await Permission.microphone.isGranted;
    emit(
      state.copyWith(
        isMicrophoneButtonEnabled: isRecordGranted,
      ),
    );
    if (!isRecordGranted) {
      return;
    }

    final fileName = '${AppConstants.recordFileName}.${_recordFileExt.name}';
    await _recorder?.startRecorder(
      toFile: fileName,
      codec: _codec,
    );

    _recordingProgressSubscription = _recorder?.onProgress?.listen((e) async {
      if (e.duration.inSeconds > AppConstants.maxRecordDurationInSec) {
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
    final s = S.of(_context);

    _recordingProgressSubscription?.cancel();
    _recordingProgressSubscription = null;

    String? recordingPath = await _recorder?.stopRecorder();
    logger.i("recorded audio: $recordingPath");

    bool isSendButtonEnabled = false;
    if (recordingPath != null && recordingPath.isNotEmpty) {
      final File audiofile = File(recordingPath);
      final Metadata metaAudio = await MetadataRetriever.fromFile(audiofile);

      _recordAudioDuration = (metaAudio.trackDuration ?? 0) / 1000;
      if (_recordAudioDuration! < AppConstants.minRecordDurationInSec) {
        updateErrorMessage(s.youCantSendThisMessageBecauseItsLessThan15Seconds);
      } else if (_recordAudioDuration! > AppConstants.maxRecordDurationInSec) {
        updateErrorMessage(
            s.recordingStoppedBecauseAudioFileIsReachedTheLimitOf3min);
        isSendButtonEnabled = true;
      } else if (audiofile.sizeInMb > AppConstants.maxFileSizeInMb) {
        updateErrorMessage(s.theMaximumImageSizeIs20Mb);
      } else {
        isSendButtonEnabled = true;
      }
    }

    emit(
      state.copyWith(
        recordingPath: recordingPath ?? '',
        isAudioFileSaved: true,
        isRecordingAudio: false,
        isSendButtonEnabled: isSendButtonEnabled,
      ),
    );
  }

  Future<void> cancelRecordingAudio() async {
    _recordingProgressSubscription?.cancel();
    _recordingProgressSubscription = null;

    await _recorder?.stopRecorder();

    emit(
      state.copyWith(
        recordingPath: null,
        isRecordingAudio: false,
        isAudioFileSaved: false,
      ),
    );
  }

  Future<void> deletedRecordedAudio() async {
    if (_playerRecorded != null && _playerRecorded!.isPlaying) {
      await _playerRecorded?.stopPlayer();
    }

    emit(
      state.copyWith(
        recordingPath: null,
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
    final images = List.of(state.attachedPictures);
    if (image != null && images.length < 2) {
      if (image.sizeInMb > AppConstants.maxFileSizeInMb) {
        updateErrorMessage(S.of(_context).theMaximumImageSizeIs20Mb);
        return;
      }

      images.add(image);
      emit(state.copyWith(
        attachedPictures: images,
      ));
    }
  }

  void deletePicture(File? image) {
    final images = List.of(state.attachedPictures);
    images.remove(image);
    emit(state.copyWith(attachedPictures: images));
  }

  void deleteAttachedPictures() {
    for (var image in state.attachedPictures) {
      deletePicture(image);
    }
  }

  startAnswer(String questionId) async {
    await _repository.startAnswer(AnswerRequest(questionID: questionId));
  }

  Future<void> sendMediaAnswer() async {
    if (_playerRecorded != null && _playerRecorded!.isPlaying) {
      await _playerRecorded!.stopPlayer();
    }

    _answerRequest = await _createMediaAnswerRequest();
    final ChatItem? answer = await _sendAnswer();
    final messages = List.of(state.activeMessages);

    if (answer != null) {
      messages.add(answer);
      emit(
        state.copyWith(
          isRecordingAudio: false,
          isAudioFileSaved: false,
          isPlayingRecordedAudio: false,
          recordingPath: null,
          activeMessages: messages,
        ),
      );
      deleteAttachedPictures();

      if (answer.isSent) {
        _mainCubit.updateSessions();
      }
    }
  }

  Future<void> sendTextMediaAnswer() async {
    _answerRequest = await _createTextMediaAnswerRequest();
    final ChatItem? answer = await _sendAnswer();
    final messages = List.of(state.activeMessages);

    if (answer != null) {
      messages.add(answer);
      emit(
        state.copyWith(
          activeMessages: messages,
        ),
      );
      textEditingController.clear();
      deleteAttachedPictures();

      if (answer.isSent) {
        _mainCubit.updateSessions();
      }
    }
  }

  sendAnswerAgain() async {
    try {
      if (_answerRequest == null) {
        return;
      }

      final ChatItem answer = await _repository.sendAnswer(_answerRequest!);
      logger.i('send text response:$answer');
      _answerRequest = null;

      final messages = List.of(state.activeMessages);
      messages.replaceRange(messages.length - 1, messages.length, [
        answer.copyWith(
          isAnswer: true,
          type: questionFromArguments?.type,
          ritualIdentifier: questionFromArguments?.ritualIdentifier,
        )
      ]);
      emit(
        state.copyWith(
          activeMessages: messages,
        ),
      );

      _mainCubit.updateSessions();
    } catch (e) {
      logger.e(e);
    }
  }

  void changeCurrentTabIndex(int newIndex) {
    emit(state.copyWith(currentTabIndex: newIndex));
  }

  void updateErrorMessage(String message) {
    emit(state.copyWith(errorMessage: message));
  }

  void updateSuccessMessage(String message) {
    emit(state.copyWith(successMessage: message));
  }

  void clearErrorMessage() {
    if (state.errorMessage.isNotEmpty) {
      emit(state.copyWith(errorMessage: ''));
    }
  }

  void clearSuccessMessage() {
    if (state.successMessage.isNotEmpty) {
      _counterMessageCleared = state.successMessage.contains(S
          .of(_context)
          .thisQuestionWillBeReturnedToTheGeneralListAfterCounter);
      emit(state.copyWith(successMessage: ''));
    }
  }

  Future<bool> _getQuestion() async {
    try {
      final ChatItem question =
          await _repository.getQuestion(id: questionFromArguments?.id ?? '');
      _takenDate = question.takenDate;
      final List<ChatItem> messages = List.of(state.activeMessages);
      messages.insert(0, question);
      emit(state.copyWith(
        activeMessages: messages,
      ));
      return true;
    } on DioError catch (e) {
      await showOkCancelAlert(
        context: _context,
        title: _mainCubit.state.errorMessage,
        okText: S.of(_context).ok,
        actionOnOK: () {
          Get.offNamed(AppRoutes.home,
              arguments: HomeScreenArguments(initTab: TabsTypes.sessions));
        },
        allowBarrierClock: false,
        isCancelEnabled: false,
      );
      logger.d(e);
      return false;
    }
  }

  void _checkTiming() {
    if (_takenDate != null &&
        state.questionStatus == ChatItemStatusType.taken) {
      int afterTakenInSec =
          DateTime.now().toUtc().difference(_takenDate!).inSeconds;
      if (afterTakenInSec < _tillShowMessagesInSec + _afterShowMessagesInSec) {
        int tillShowMessagesInSec = _tillShowMessagesInSec;
        int afterShowMessagesInSec = _afterShowMessagesInSec;

        if (afterTakenInSec < _tillShowMessagesInSec) {
          tillShowMessagesInSec = _tillShowMessagesInSec - afterTakenInSec;
        } else if (afterTakenInSec <
            _tillShowMessagesInSec + _afterShowMessagesInSec) {
          tillShowMessagesInSec = 0;
          afterShowMessagesInSec = _afterShowMessagesInSec - afterTakenInSec;
        }

        if (afterShowMessagesInSec < 60) {
          _setAnswerIsNotPossible();
        }

        _startTimer(tillShowMessagesInSec, afterShowMessagesInSec);
      } else {
        returnQuestion();
      }
    }
  }

  _startTimer(int tillShowMessagesInSec, int afterShowMessagesInSec) async {
    final s = S.of(_context);
    _answerTimer = Timer(Duration(seconds: tillShowMessagesInSec), () {
      if (state.questionStatus == ChatItemStatusType.taken) {
        const minuteInSec = 60;
        const tick = Duration(seconds: 1);
        Duration tillEnd = Duration(seconds: afterShowMessagesInSec);

        _answerTimer = Timer.periodic(tick, (_) {
          tillEnd = tillEnd - tick;
          if (tillEnd.inSeconds > minuteInSec) {
            if (!_counterMessageCleared) {
              updateSuccessMessage(
                  "${s.thisQuestionWillBeReturnedToTheGeneralListAfterCounter} ${tillEnd.formatMMSS}");
            }
          } else if (tillEnd.inSeconds == minuteInSec) {
            _setAnswerIsNotPossible();
          }
          if (tillEnd.inSeconds == 0) {
            returnQuestion();
            clearSuccessMessage();
          }
        });
      } else {
        _answerTimer = null;
      }
    });
  }

  _setAnswerIsNotPossible() {
    updateSuccessMessage(S
        .of(_context)
        .theAnswerIsNotPossibleThisQuestionWillBeReturnedToTheGeneralListIn1m);
    emit(state.copyWith(
      isInputField: false,
    ));
  }

  Future<AnswerRequest> _createMediaAnswerRequest() async {
    final Attachment? audioAttachment = await _getAudioAttachment();
    Attachment? pictureAttachment;
    if (isAttachedPictures) {
      pictureAttachment = await _getPictureAttachment(0);
    }

    final answerRequest = AnswerRequest(
      questionID: questionFromArguments?.id,
      ritualID: questionFromArguments?.ritualIdentifier,
      attachments: [
        audioAttachment!,
        if (pictureAttachment != null) pictureAttachment,
      ],
    );

    return answerRequest;
  }

  Future<AnswerRequest> _createTextMediaAnswerRequest() async {
    Attachment? pictureAttachment1 =
        isAttachedPictures ? await _getPictureAttachment(0) : null;
    Attachment? pictureAttachment2 = state.attachedPictures.length == 2
        ? await _getPictureAttachment(1)
        : null;

    final answerRequest = AnswerRequest(
      questionID: questionFromArguments?.id,
      ritualID: questionFromArguments?.ritualIdentifier,
      content: textEditingController.text.isEmpty
          ? null
          : textEditingController.text,
      attachments: [
        if (pictureAttachment1 != null) pictureAttachment1,
        if (pictureAttachment2 != null) pictureAttachment2,
      ],
    );

    return answerRequest;
  }

  Future<ChatItem?> _sendAnswer() async {
    _answerTimer?.cancel();
    _answerTimer = null;

    final s = S.of(_context);
    ChatItem? answer;
    try {
      answer = await _repository.sendAnswer(_answerRequest!);
      logger.d('send answer response: $answer');
      if (answer.type == ChatItemType.textAnswer) {
        _setQuestionStatus(ChatItemStatusType.answered);
      }
      answer = answer.copyWith(
        isAnswer: true,
        type: questionFromArguments?.type,
        ritualIdentifier: questionFromArguments?.ritualIdentifier,
      );
      _answerRequest = null;
    } on DioError catch (e) {
      logger.e(e);
      if (!await ConnectivityService.checkConnection() ||
          e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        updateErrorMessage(s.checkYourInternetConnection);
        answer = _getNotSentAnswer();
      }
    }
    return answer;
  }

  ChatItem _getNotSentAnswer() {
    String? picturePath1 = _getAttachedPicturePath(0);
    String? picturePath2 = _getAttachedPicturePath(1);
    String? recordingPath = state.recordingPath;

    final ChatItem answer = ChatItem(
      isAnswer: true,
      isSent: false,
      type: questionFromArguments?.type,
      ritualIdentifier: questionFromArguments?.ritualIdentifier,
      content: _answerRequest!.content,
      attachments: [
        if (recordingPath != null)
          _answerRequest!.attachments![0].copyWith(
            url: recordingPath,
            attachment: null,
          ),
        if (picturePath1 != null)
          _answerRequest!.attachments![recordingPath == null ? 0 : 1].copyWith(
            url: picturePath1,
            attachment: null,
          ),
        if (picturePath2 != null)
          _answerRequest!.attachments![1].copyWith(
            url: picturePath2,
            attachment: null,
          ),
      ],
    );
    return answer;
  }

  String? _getAttachedPicturePath(int n) {
    return state.attachedPictures.length >= n + 1
        ? state.attachedPictures[n].path
        : null;
  }

  Future<Attachment?> _getAudioAttachment() async {
    if (state.recordingPath == null) {
      return null;
    }

    final File audiofile = File(state.recordingPath!);
    final List<int> audioBytes = await audiofile.readAsBytes();
    final String base64Audio = base64Encode(audioBytes);

    return Attachment(
        mime: lookupMimeType(state.recordingPath!),
        attachment: base64Audio,
        meta: Meta(duration: _recordAudioDuration));
  }

  Future<Attachment> _getPictureAttachment(int n) async {
    final File imageFile = state.attachedPictures[n];
    final List<int> imageBytes = await imageFile.readAsBytes();
    final String base64Image = base64Encode(imageBytes);
    return Attachment(
      mime: lookupMimeType(imageFile.path),
      attachment: base64Image,
    );
  }

  ChatItem? get question => questionFromArguments;

  int get minTextLength => questionFromArguments?.type == ChatItemType.ritual
      ? AppConstants.minTextLengthRirual
      : AppConstants.minTextLengthPublic;

  int get maxTextLength => questionFromArguments?.type == ChatItemType.ritual
      ? AppConstants.maxTextLengthRitual
      : AppConstants.maxTextLengthPublic;

  bool get isAttachedPictures => state.attachedPictures.isNotEmpty;

  Stream<PlaybackDisposition>? get onMediaProgress => _playerMedia?.onProgress;
}
