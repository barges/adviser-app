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
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/data/models/app_errors/empty_error.dart';
import 'package:shared_advisor_interface/data/models/app_errors/ui_error.dart';
import 'package:shared_advisor_interface/data/models/app_success/app_success.dart';
import 'package:shared_advisor_interface/data/models/app_success/empty_success.dart';
import 'package:shared_advisor_interface/data/models/app_success/ui_success.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/chats/meta.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'chat_state.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audio_session/audio_session.dart';

const _recordFileExt = 'm4a';

class ChatCubit extends Cubit<ChatState> {
  final ScrollController activeMessagesScrollController = ScrollController();
  final ScrollController historyMessagesScrollController = ScrollController();
  final ScrollController textInputScrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();

  final CachingManager _cachingManager;
  final ChatsRepository _repository;
  late final ChatScreenArguments chatScreenArguments;
  final VoidCallback _showErrorAlert;
  final MainCubit _mainCubit = getIt.get<MainCubit>();
  final Codec _codec = Codec.aacMP4;
  final int _tillShowMessagesInSec =
      AppConstants.tillShowAnswerTimingMessagesInSec;
  final int _afterShowMessagesInSec =
      AppConstants.afterShowAnswerTimingMessagesInSec;
  final int _limit = 25;
  int _offset = 0;
  int? _total;
  num? _recordAudioDuration;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _playerRecorded;
  FlutterSoundPlayer? playerMedia;
  AnswerRequest? _answerRequest;
  StreamSubscription<RecordingDisposition>? _recordingProgressSubscription;
  Timer? _answerTimer;
  bool _counterMessageCleared = false;

  ChatCubit(
    this._cachingManager,
    this._repository,
    this._showErrorAlert,
  ) : super(const ChatState()) {
    chatScreenArguments = Get.arguments;
    _init();
    if (chatScreenArguments.question != null) {
      emit(
        state.copyWith(
          questionFromDB: chatScreenArguments.question,
          questionStatus:
              chatScreenArguments.question?.status ?? ChatItemStatusType.open,
          activeMessages: [chatScreenArguments.question!],
        ),
      );
    }
    _getData().whenComplete(_checkTiming);
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

    playerMedia?.closePlayer();
    playerMedia = null;

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
    playerMedia = await FlutterSoundPlayer(logLevel: logLevel).openPlayer();

    await _recorder?.setSubscriptionDuration(
      const Duration(seconds: 1),
    );

    await _playerRecorded?.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );

    await playerMedia?.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );

    //activeMessagesScrollController.addListener(scrollControllerListener);
    historyMessagesScrollController.addListener(scrollControllerListener);

    textEditingController.addListener(textEditingControllerListener);
  }

  Future<void> _getData() async {
    await _getPublicOrPrivateQuestion();
    await _getConversations();
  }

  Future<void> _initAudioSession() async {
    final AudioSession session = await AudioSession.instance;
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

  Future<bool> _getPublicOrPrivateQuestion() async {
    try {
      ChatItem? question;
      if (chatScreenArguments.publicQuestionId != null) {
        question = await _repository.getQuestion(
            id: chatScreenArguments.publicQuestionId ?? '');
      } else if (chatScreenArguments.privateQuestionId != null) {
        question = await _repository.getQuestion(
            id: chatScreenArguments.privateQuestionId ?? '');
      }
      if (question != null) {
        emit(
          state.copyWith(
            questionFromDB: question,
            questionStatus: question.status,
            activeMessages: [question],
          ),
        );
        return true;
      }
      return false;
    } on DioError catch (e) {
      _showErrorAlert();
      logger.d(e);
      return false;
    }
  }

  Future<void> _getConversations() async {
    if (_total != null && _offset >= _total!) {
      return;
    }

    ConversationsResponse conversations =
        await _repository.getConversationsHistory(
            expertID: _cachingManager.getUserId() ?? '',
            clientID: chatScreenArguments.clientId,
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
      final ChatItem question = await _repository.takeQuestion(
        AnswerRequest(
          questionID: chatScreenArguments.publicQuestionId,
        ),
      );
      emit(
        state.copyWith(
          questionStatus: question.status ?? ChatItemStatusType.open,
        ),
      );
      _mainCubit.updateSessions();
      if (question.status == ChatItemStatusType.taken) {
        _startTimer(_tillShowMessagesInSec, _afterShowMessagesInSec);
      }
    } on DioError catch (e) {
      _showErrorAlert();
      logger.d(e);
    }
  }

  Future<void> returnQuestion() async {
    try {
      final ChatItem question = await _repository.returnQuestion(
        AnswerRequest(
          questionID: chatScreenArguments.publicQuestionId,
        ),
      );
      emit(
        state.copyWith(
          questionStatus: question.status ?? ChatItemStatusType.open,
          isInputField: true,
        ),
      );

      ///TODO: Why we need emit???

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

    const fileName = '${AppConstants.recordFileName}.$_recordFileExt';
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
        updateErrorMessage(UIError(
            uiErrorType:
                UIErrorType.youCantSendThisMessageBecauseItsLessThan15Seconds));
      } else if (_recordAudioDuration! > AppConstants.maxRecordDurationInSec) {
        updateErrorMessage(UIError(
            uiErrorType: UIErrorType
                .recordingStoppedBecauseAudioFileIsReachedTheLimitOf3min));
        isSendButtonEnabled = true;
      } else if (audiofile.sizeInMb > AppConstants.maxFileSizeInMb) {
        updateErrorMessage(
            UIError(uiErrorType: UIErrorType.theMaximumImageSizeIs20Mb));
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
      await playerMedia?.stopPlayer();

      emit(
        state.copyWith(
          isPlayingAudio: false,
          isPlayingAudioFinished: true,
          audioUrl: audioUrl,
        ),
      );
    }

    if (playerMedia != null && playerMedia!.isPaused) {
      await playerMedia!.resumePlayer();

      emit(
        state.copyWith(
          isPlayingAudio: true,
          isPlayingAudioFinished: false,
        ),
      );
      return;
    }

    await playerMedia?.startPlayer(
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
    await playerMedia?.pausePlayer();

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
        updateErrorMessage(
            UIError(uiErrorType: UIErrorType.theMaximumImageSizeIs20Mb));
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

      ///TODO: Maybe we need get data from backend for all sendMessage methods ("storyID":"62e37a673b6d20001df860ef")
      ///{"expertInformation":{"profile":{"profilePictures":["https://fortunica-data.s3.eu-central-1.amazonaws.com/experts/b1c895e92b88b543979ba987bb8236e3.jpg"],
      ///"profileName":"Niskov Max"},"_id":"39726a57734b49a530639cc8115eb863e3f064fc16c2955384770462efb5e44b"},
      ///"deleted":false,"answerTime":11614090070,"_id":"6394b1f1cd073b001d0055ac",
      ///"content":"","attachments":[{"_id":"6394b1f1cd073b001d0055ad","mime":"image/jpeg",
      ///"url":"https://fortunica-data.s3.eu-central-1.amazonaws.com/attachments/9639bf2d33857e9c636292defca140f6.jpg","meta":null}],
      ///"storyID":"62e37a673b6d20001df860ef","type":"TEXT_ANSWER",
      ///"clientID":"5f5224f45a1f7c001c99763c","expertID":"39726a57734b49a530639cc8115eb863e3f064fc16c2955384770462efb5e44b",
      ///"questionID":"62e37a673b6d20001df860f1","questionType":"PUBLIC","likes":[],
      ///"createdAt":"2022-12-10T16:21:05.895Z","updatedAt":"2022-12-10T16:21:05.895Z","__v":0}
      messages.replaceRange(messages.length - 1, messages.length, [
        answer.copyWith(
          isAnswer: true,
          type: state.questionFromDB?.type,
          ritualIdentifier: state.questionFromDB?.ritualIdentifier,
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

  void updateErrorMessage(AppError appError) {
    emit(state.copyWith(appError: appError));
  }

  void updateSuccessMessage(AppSuccess appSuccess) {
    emit(state.copyWith(appSuccess: appSuccess));
  }

  void clearErrorMessage() {
    if (state.appError is! EmptyError) {
      emit(state.copyWith(appError: const EmptyError()));
    }
  }

  void clearSuccessMessage() {
    if (state.appSuccess is! EmptySuccess) {
      _counterMessageCleared = state.appSuccess.uiSuccessType ==
          UISuccessType.thisQuestionWillBeReturnedToTheGeneralListAfterCounter;
      emit(state.copyWith(appSuccess: const EmptySuccess()));
    }
  }

  void _checkTiming() {
    final ChatItem? publicQuestion = state.activeMessages.firstOrNull;
    if (publicQuestion?.status == ChatItemStatusType.taken &&
        publicQuestion?.takenDate != null) {
      int afterTakenInSec = DateTime.now()
          .toUtc()
          .difference(publicQuestion!.takenDate!)
          .inSeconds;
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
    _answerTimer = Timer(Duration(seconds: tillShowMessagesInSec), () {
      if (state.questionStatus == ChatItemStatusType.taken) {
        const minuteInSec = 60;
        const tick = Duration(seconds: 1);
        Duration tillEnd = Duration(seconds: afterShowMessagesInSec);

        _answerTimer = Timer.periodic(tick, (_) {
          tillEnd = tillEnd - tick;
          if (tillEnd.inSeconds > minuteInSec) {
            if (!_counterMessageCleared) {
              updateSuccessMessage(UISuccess.withArguments(
                  UISuccessType
                      .thisQuestionWillBeReturnedToTheGeneralListAfterCounter,
                  tillEnd.formatMMSS));
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
    updateSuccessMessage(UISuccess(UISuccessType
        .theAnswerIsNotPossibleThisQuestionWillBeReturnedToTheGeneralListIn1m));

    emit(
      state.copyWith(
        isInputField: false,
      ),
    );
  }

  Future<AnswerRequest> _createMediaAnswerRequest() async {
    final Attachment? audioAttachment = await _getAudioAttachment();
    Attachment? pictureAttachment;
    if (isAttachedPictures) {
      pictureAttachment = await _getPictureAttachment(0);
    }

    final answerRequest = AnswerRequest(
      questionID: state.questionFromDB?.id,
      ritualID: state.questionFromDB?.ritualIdentifier,
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
      questionID: state.questionFromDB?.id,
      ritualID: state.questionFromDB?.ritualIdentifier,
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

    ChatItem? answer;
    try {
      answer = await _repository.sendAnswer(_answerRequest!);
      logger.d('send answer response: $answer');
      if (answer.type == ChatItemType.textAnswer) {
        emit(state.copyWith(questionStatus: ChatItemStatusType.answered));
      }
      answer = answer.copyWith(
        isAnswer: true,
        type: state.questionFromDB?.type,
        ritualIdentifier: state.questionFromDB?.ritualIdentifier,
      );
      _answerRequest = null;
    } on DioError catch (e) {
      logger.e(e);
      if (!await ConnectivityService.checkConnection() ||
          e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        updateErrorMessage(
            UIError(uiErrorType: UIErrorType.checkYourInternetConnection));
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
      type: state.questionFromDB?.type,
      ritualIdentifier: state.questionFromDB?.ritualIdentifier,
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

  int get minTextLength => state.questionFromDB?.type == ChatItemType.ritual
      ? AppConstants.minTextLengthRirual
      : AppConstants.minTextLengthPublic;

  int get maxTextLength => state.questionFromDB?.type == ChatItemType.ritual
      ? AppConstants.maxTextLengthRitual
      : AppConstants.maxTextLengthPublic;

  bool get isAttachedPictures => state.attachedPictures.isNotEmpty;

  Stream<PlaybackDisposition>? get onMediaProgress => playerMedia?.onProgress;
}
