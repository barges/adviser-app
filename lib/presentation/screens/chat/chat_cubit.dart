import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/chats/client_information.dart';
import 'package:shared_advisor_interface/data/models/chats/meta.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_story_response.dart';
import 'package:shared_advisor_interface/data/network/responses/rituals_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

import 'chat_state.dart';

const String _recordFileExt = 'm4a';
const int _storyLimit = 20;

class ChatCubit extends Cubit<ChatState> {
  final ScrollController activeMessagesScrollController = ScrollController();
  final ScrollController textInputScrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  final ChatsRepository _repository;
  late final ChatScreenArguments chatScreenArguments;
  final VoidCallback _showErrorAlert;
  final BuildContext _context;
  final MainCubit _mainCubit = getIt.get<MainCubit>();
  final Codec _codec = Codec.aacMP4;
  final int _tillShowMessagesInSec =
      AppConstants.tillShowAnswerTimingMessagesInSec;
  final int _afterShowMessagesInSec =
      AppConstants.afterShowAnswerTimingMessagesInSec;
  num? _recordAudioDuration;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _playerRecorded;
  FlutterSoundPlayer? _playerMedia;
  AnswerRequest? _answerRequest;
  StreamSubscription<RecordingDisposition>? _recordingProgressSubscription;
  Timer? _answerTimer;
  bool _counterMessageCleared = false;
  bool _isStartAnswerSending = false;

  final List<ChatItem> _storyQuestionsList = [];
  String? _lastQuestionIdForStory;

  ChatCubit(
    this._repository,
    this._showErrorAlert,
    this._context,
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
    _getData().whenComplete(() {
      if (chatScreenArguments.publicQuestionId != null) {
        _checkTiming();
      }
    });
  }

  @override
  Future<void> close() {
    activeMessagesScrollController.dispose();

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

    textEditingController.addListener(textEditingControllerListener);
  }

  Future<void> _getData() async {
    if (chatScreenArguments.publicQuestionId != null) {
      await _getPublicQuestion();
    } else if (chatScreenArguments.ritualId != null) {
      _getRituals();
    } else if (chatScreenArguments.storyId != null) {
      _getStory();
    }
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

  void textEditingControllerListener() {
    _tryStartAnswer();

    final textLength = textEditingController.text.length;
    emit(
      state.copyWith(
        inputTextLength: textEditingController.text.length,
        isSendButtonEnabled:
            textLength >= minTextLength && textLength <= maxTextLength,
      ),
    );
  }

  Future<void> _getPublicQuestion() async {
    try {
      if (chatScreenArguments.publicQuestionId != null) {
        final ChatItem question = await _repository.getQuestion(
            id: chatScreenArguments.publicQuestionId!);

        emit(
          state.copyWith(
            questionFromDB: question,
            questionStatus: question.status,
            activeMessages: [question],
          ),
        );
      }
    } on DioError catch (e) {
      _showErrorAlert();
      logger.d(e);
    }
  }

  Future<void> _getRituals() async {
    try {
      if (chatScreenArguments.ritualId != null) {
        final RitualsResponse ritualsResponse =
            await _repository.getRituals(id: chatScreenArguments.ritualId!);

        final List<ChatItem>? questions = ritualsResponse.story?.questions;
        final List<ChatItem>? answers = ritualsResponse.story?.answers;

        if (questions != null && questions.isNotEmpty && answers != null) {
          _fillStoryQuestionsList(questions, answers);

          final ChatItem lastQuestion = questions.last;
          final ClientInformation? clientInformation =
              ritualsResponse.clientInformation;

          emit(
            state.copyWith(
              questionFromDB: lastQuestion.copyWith(
                clientID: ritualsResponse.clientID,
                clientName:
                    '${clientInformation?.firstName ?? ''} ${clientInformation?.lastName ?? ''}',
              ),
              questionStatus: lastQuestion.status,
              activeMessages: _storyQuestionsList,
            ),
          );
        }
      }
    } on DioError catch (e) {
      _showErrorAlert();
      logger.d(e);
    }
  }

  Future<void> _getStory() async {
    try {
      if (chatScreenArguments.storyId != null) {
        final ConversationsStoryResponse storyResponse =
            await _repository.getStory(
          storyID: chatScreenArguments.storyId!,
          limit: _storyLimit,
          lastQuestionId: _lastQuestionIdForStory,
        );
        final List<ChatItem>? questions = storyResponse.questions;
        final List<ChatItem>? answers = storyResponse.answers;

        if (questions != null && questions.isNotEmpty && answers != null) {
          // _lastQuestionIdForStory
          _fillStoryQuestionsList(questions, answers);

          final ChatItem lastQuestion = questions.last;

          emit(
            state.copyWith(
              questionFromDB: lastQuestion.copyWith(
                clientID: storyResponse.clientID,
              ),
              questionStatus: lastQuestion.status,
              activeMessages: _storyQuestionsList,
            ),
          );
        }
      }
    } on DioError catch (e) {
      _showErrorAlert();
      logger.d(e);
    }
  }

  void _fillStoryQuestionsList(
      List<ChatItem> questions, List<ChatItem> answers) {
    for (int i = 0; i < questions.length; i++) {
      if (i < answers.length) {
        _storyQuestionsList.add(answers[i].copyWith(
          isAnswer: true,
          type: questions[i].type,
          ritualId: questions[i].ritualId,
        ));
      }
      _storyQuestionsList.add(questions[i]);
    }
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
      await _repository.returnQuestion(
        AnswerRequest(
          questionID: chatScreenArguments.publicQuestionId,
        ),
      );
    } catch (e) {
      logger.d(e);
    }

    _mainCubit.updateSessions();
    Get.back();
    _answerTimer?.cancel();
    _answerTimer = null;
  }

  Future<void> startRecordingAudio() async {
    _tryStartAnswer();

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
    _tryStartAnswer();

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

  Future<void> sendMediaAnswer() async {
    if (_playerRecorded != null && _playerRecorded!.isPlaying) {
      await _playerRecorded!.stopPlayer();
    }

    _answerRequest = await _createMediaAnswerRequest();
    final ChatItem? answer = await _sendAnswer();

    if (answer != null) {
      final List<ChatItem> messages = List.of(state.activeMessages);
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

    if (answer != null) {
      final messages = List.of(state.activeMessages);
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

  void sendAnswerAgain() async {
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

  void _tryStartAnswer() {
    if (!_isStartAnswerSending &&
        chatScreenArguments.publicQuestionId == null &&
        state.questionFromDB?.id != null &&
        state.questionFromDB?.startAnswerDate == null) {
      _startAnswer(state.questionFromDB!.id!);
    }
  }

  Future<void> _startAnswer(String questionId) async {
    try {
      _isStartAnswerSending = true;
      final ChatItem question =
          await _repository.startAnswer(AnswerRequest(questionID: questionId));
      emit(
        state.copyWith(
          questionFromDB: state.questionFromDB
              ?.copyWith(startAnswerDate: question.startAnswerDate),
        ),
      );
    } on DioError catch (e) {
      logger.e(e);
    }

    _isStartAnswerSending = false;
  }

  void _checkTiming() {
    final ChatItem? publicQuestion = state.questionFromDB;
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

  void _startTimer(
      int tillShowMessagesInSec, int afterShowMessagesInSec) async {
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

  void _setAnswerIsNotPossible() {
    updateSuccessMessage(S
        .of(_context)
        .theAnswerIsNotPossibleThisQuestionWillBeReturnedToTheGeneralListIn1m);
    emit(
      state.copyWith(
        showInputFieldIfPublic: false,
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

    final s = S.of(_context);
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

  Stream<PlaybackDisposition>? get onMediaProgress => _playerMedia?.onProgress;
}
