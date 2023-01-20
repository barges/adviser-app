import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_sound/flutter_sound.dart' hide PlayerState;
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/data/models/app_errors/ui_error_type.dart';
import 'package:shared_advisor_interface/data/models/app_success/app_success.dart';
import 'package:shared_advisor_interface/data/models/app_success/ui_success_type.dart';
import 'package:shared_advisor_interface/data/models/chats/answer_limitation.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/chats/content_limitation.dart';
import 'package:shared_advisor_interface/data/models/chats/meta.dart';
import 'package:shared_advisor_interface/data/models/enums/attachment_type.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/data/models/enums/message_content_type.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_types.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/answer_validation_response.dart';
import 'package:shared_advisor_interface/data/network/responses/rituals_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/services/check_permission_service.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/audio_player_service.dart';
import 'package:shared_advisor_interface/presentation/services/sound/sound_record_service.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

import 'chat_state.dart';

const String _recordFileExt = 'm4a';

class ChatCubit extends Cubit<ChatState> {
  final ScrollController activeMessagesScrollController = ScrollController();
  final ScrollController textInputScrollController = ScrollController();
  final TextEditingController textInputEditingController =
      TextEditingController();

  GlobalKey? questionGlobalKey;

  final ConnectivityService _connectivityService;

  late final StreamSubscription<bool> _keyboardSubscription;

  final ChatsRepository _repository;
  late final ChatScreenArguments chatScreenArguments;
  final VoidCallback _showErrorAlert;
  final ValueGetter<Future<bool?>> _confirmSendAnswerAlert;
  final ValueGetter<Future<bool?>> _deleteAudioMessageAlert;
  final MainCubit _mainCubit;
  final AudioPlayerService audioPlayer;
  final SoundRecordService _soundRecordService;
  final int _tillShowMessagesInSec =
      AppConstants.tillShowAnswerTimingMessagesInSec;
  final int _afterShowMessagesInSec =
      AppConstants.afterShowAnswerTimingMessagesInSec;
  int? _recordAudioDuration;
  AnswerRequest? _answerRequest;
  StreamSubscription<RecordingDisposition>? _recordingProgressSubscription;

  Timer? _answerTimer;
  bool _counterMessageCleared = false;
  bool _isStartAnswerSending = false;

  static List<AnswerLimitation> _answerLimitations = [];

  ChatCubit(
    this._repository,
    this._connectivityService,
    this._mainCubit,
    this._soundRecordService,
    this.audioPlayer,
    this._showErrorAlert,
    this._confirmSendAnswerAlert,
    this._deleteAudioMessageAlert,
  ) : super(const ChatState()) {
    chatScreenArguments = Get.arguments;

    textInputEditingController.addListener(textInputEditingControllerListener);

    if (chatScreenArguments.clientIdFromPush != null) {
      emit(
        state.copyWith(
          questionFromDB:
              ChatItem(clientID: chatScreenArguments.clientIdFromPush),
        ),
      );
    } else if (chatScreenArguments.question != null) {
      emit(
        state.copyWith(
          questionFromDB: chatScreenArguments.question,
          questionStatus:
              chatScreenArguments.question?.status ?? ChatItemStatusType.open,
          activeMessages: [chatScreenArguments.question!],
        ),
      );
    }
    if (needActiveChatTab()) {
      _getData().whenComplete(() {
        if (isPublicChat()) {
          _checkTiming();
        }
      });
    }

    _keyboardSubscription =
        KeyboardVisibilityController().onChange.listen((bool visible) {
      if (visible) {
        if (questionGlobalKey != null) {
          Future.delayed(const Duration(milliseconds: 300))
              .then((value) => Utils.animateToWidget(questionGlobalKey!));
        }
      }
    });
  }

  @override
  Future<void> close() async {
    if (state.isRecordingAudio) {
      await cancelRecordingAudio();
    }
    _deleteRecordedAudioFile(state.recordedAudio);
    _recordAudioDuration = null;

    activeMessagesScrollController.dispose();

    _keyboardSubscription.cancel();

    textInputScrollController.dispose();
    textInputEditingController.dispose();

    _soundRecordService.close();
    audioPlayer.dispose();

    _recordingProgressSubscription?.cancel();
    _recordingProgressSubscription = null;

    _answerTimer?.cancel();
    _answerTimer = null;

    _answerRequest = null;

    return super.close();
  }

  Future<void> _getData() async {
    if (_answerLimitations.isEmpty) {
      await _getAnswerLimitations();
    }

    if (chatScreenArguments.ritualID != null) {
      _getRituals(chatScreenArguments.ritualID!).then((_) async {
        scrollChatDown();
      });
    } else {
      await _getPublicOrPrivateQuestion();
    }
  }

  Future<void> _getAnswerLimitations() async {
    final AnswerValidationResponse response =
        await _repository.getAnswerValidation();
    _answerLimitations = response.answerLimitations ?? [];
  }

  void textInputEditingControllerListener() {
    _tryStartAnswerSend();
    emit(
      state.copyWith(
        inputTextLength: textInputEditingController.text.length,
        isSendButtonEnabled:
            _checkTextLengthIsOk() || state.recordedAudio != null,
      ),
    );
  }

  void updateAppBarInformation(
      CustomerProfileScreenArguments? appBarUpdateArguments) {
    emit(state.copyWith(
      appBarUpdateArguments: appBarUpdateArguments,
    ));
  }

  Future<void> _getPublicOrPrivateQuestion() async {
    try {
      ChatItem? question;
      if (chatScreenArguments.publicQuestionId != null) {
        question = await _repository.getQuestion(
            id: chatScreenArguments.publicQuestionId!);
      } else if (chatScreenArguments.privateQuestionId != null) {
        question = await _repository.getQuestion(
            id: chatScreenArguments.privateQuestionId!);
      }

      if (question != null) {
        emit(
          state.copyWith(
            questionFromDB: question,
            questionStatus: question.status,
            activeMessages: [question],
            isAudioAnswerEnabled: question.isAudio,
          ),
        );
      }
    } on DioError catch (e) {
      if (_checkStatusCode(e)) {
        _showErrorAlert();
      }
      logger.d(e);
    }
  }

  Future<void> _getRituals(String ritualId) async {
    try {
      final RitualsResponse ritualsResponse =
          await _repository.getRituals(id: ritualId);

      final List<ChatItem>? questions = ritualsResponse.story?.questions;
      final List<ChatItem>? answers = ritualsResponse.story?.answers;
      final SessionsTypes? ritualIdentifier = ritualsResponse.identifier;

      if (questions != null && questions.isNotEmpty && answers != null) {
        final List<ChatItem> activeMessages = [];
        for (int i = 0; i < questions.length; i++) {
          activeMessages.add(questions[i].copyWith(
            ritualIdentifier: ritualIdentifier,
          ));
          if (i < answers.length) {
            activeMessages.add(answers[i].copyWith(
              isAnswer: true,
              type: questions[i].type,
              ritualID: questions[i].ritualID,
              ritualIdentifier: ritualIdentifier,
            ));
          }
        }

        final ChatItem lastQuestion = questions.last;

        final bool isAudioAnswerEnabled =
            questions.any((element) => element.isAudio);

        emit(
          state.copyWith(
            questionFromDB: lastQuestion.copyWith(
              clientID: ritualsResponse.clientID,
              clientName: ritualsResponse.clientName,
              ritualID: ritualId,
              ritualIdentifier: ritualIdentifier,
            ),
            questionStatus: lastQuestion.status,
            activeMessages: activeMessages,
            ritualCardInfo: ritualsResponse.ritualCardInfo,
            isAudioAnswerEnabled: isAudioAnswerEnabled,
          ),
        );

        scrollChatDown();
      }
    } on DioError catch (e) {
      if (_checkStatusCode(e)) {
        _showErrorAlert();
      }
      logger.d(e);
      rethrow;
    }
  }

  void scrollChatDown() {
    SchedulerBinding.instance.endOfFrame.then((_) =>
        activeMessagesScrollController
            .jumpTo(activeMessagesScrollController.position.maxScrollExtent));
  }

  bool needActiveChatTab() {
    return chatScreenArguments.privateQuestionId != null ||
        isPublicChat() ||
        chatScreenArguments.ritualID != null;
  }

  bool isPublicChat() {
    return chatScreenArguments.publicQuestionId != null;
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
      if (_checkStatusCode(e)) {
        _showErrorAlert();
      }
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

  Future<void> startRecordingAudio(BuildContext context) async {
    _tryStartAnswerSend();

    audioPlayer.stop();

    await CheckPermissionService.handlePermission(
        context, PermissionType.audio);

    final isRecordGranted = await Permission.microphone.isGranted;

    if (!isRecordGranted) {
      return;
    }

    const fileName = '${AppConstants.recordFileName}.$_recordFileExt';
    await _soundRecordService.startRecorder(fileName);

    _recordingProgressSubscription =
        _soundRecordService.onProgress?.listen((e) async {
      _recordAudioDuration = e.duration.inSeconds;
      if (!_checkMaxRecordDurationIsOk()) {
        stopRecordingAudio();
      }
    });

    emit(
      state.copyWith(
        isRecordingAudio: true,
        recordingStream: _soundRecordService.onProgress,
      ),
    );
  }

  Future<void> stopRecordingAudio() async {
    _recordingProgressSubscription?.cancel();
    _recordingProgressSubscription = null;

    String? recordingPath = await _soundRecordService.stopRecorder();
    logger.i("recorded audio: $recordingPath");

    bool isSendButtonEnabled = false;
    File? recordedAudio;
    if (recordingPath != null && recordingPath.isNotEmpty) {
      recordedAudio = File(recordingPath);
      final Metadata metaAudio =
          await MetadataRetriever.fromFile(recordedAudio);

      _recordAudioDuration = (metaAudio.trackDuration ?? 0) ~/ 1000;
      if (!checkMinRecordDurationIsOk()) {
        _mainCubit.updateErrorMessage(UIError(
            uiErrorType:
                UIErrorType.youCantSendThisMessageBecauseItsLessThanXSeconds,
            args: [minRecordDurationInSec]));
      } else if (!_checkMaxRecordDurationIsOk()) {
        _mainCubit.updateErrorMessage(UIError(
            uiErrorType: UIErrorType.youVeReachTheXMinuteTimeLimit,
            args: [maxRecordDurationInMinutes]));
        isSendButtonEnabled = true;
      } else {
        isSendButtonEnabled = true;
      }
    }

    emit(
      state.copyWith(
        recordedAudio: recordedAudio,
        isRecordingAudio: false,
        isSendButtonEnabled: isSendButtonEnabled &&
            _checkAttachmentSizeIsOk(state.attachedPictures, recordedAudio),
      ),
    );
  }

  Future<void> cancelRecordingAudio() async {
    _recordingProgressSubscription?.cancel();
    _recordingProgressSubscription = null;
    _recordAudioDuration = null;

    String? recordingPath = await _soundRecordService.stopRecorder();
    if (recordingPath != null && recordingPath.isNotEmpty) {
      File recordedAudio = File(recordingPath);
      await _deleteRecordedAudioFile(recordedAudio);
    }

    emit(
      state.copyWith(
        recordedAudio: null,
        isRecordingAudio: false,
      ),
    );
  }

  Future<void> deleteRecordedAudio() async {
    await audioPlayer.stop();

    if (await _deleteAudioMessageAlert() == true) {
      await _deleteRecordedAudioFile(state.recordedAudio);
      _recordAudioDuration = null;

      emit(
        state.copyWith(
            recordedAudio: null,
            isRecordingAudio: false,
            isSendButtonEnabled:
                _checkAttachmentSizeIsOk(state.attachedPictures, null) &&
                    _checkTextLengthIsOk()),
      );
    }
  }

  Future<void> _deleteRecordedAudioFile(File? recordedAudio) async {
    if (recordedAudio != null && await recordedAudio.exists()) {
      recordedAudio.deleteSync();
    }
  }

  void attachPicture(File? image) {
    _tryStartAnswerSend();

    final List<File> images = List.of(state.attachedPictures);
    if (image != null && images.length < 2) {
      images.add(image);
    } else {
      return;
    }

    emit(state.copyWith(
      attachedPictures: images,
      isSendButtonEnabled:
          _checkAttachmentSizeIsOk(images, state.recordedAudio) &&
              (_checkRecordedAudioIsOk() || _checkTextLengthIsOk()),
    ));

    _scrollTextFieldToEnd();
  }

  void deletePicture(File? image) {
    final images = List.of(state.attachedPictures);
    images.remove(image);
    emit(state.copyWith(
      attachedPictures: images,
      isSendButtonEnabled:
          (_checkRecordedAudioIsOk() || _checkTextLengthIsOk()) &&
              _checkAttachmentSizeIsOk(images, state.recordedAudio),
    ));

    _scrollTextFieldToEnd();
  }

  void deleteAttachedPictures() {
    for (var image in state.attachedPictures) {
      deletePicture(image);
    }
  }

  Future<void> sendAnswer(ChatContentType contentType) async {
    if (await _confirmSendAnswerAlert() == true) {
      switch (contentType) {
        case ChatContentType.media:
          return sendMediaAnswer();
        case ChatContentType.textMedia:
          return sendTextMediaAnswer();
      }
    }
  }

  Future<void> sendMediaAnswer() async {
    await audioPlayer.stop();

    _answerRequest = await _createMediaAnswerRequest();
    final ChatItem? answer = await _sendAnswer();

    if (answer != null) {
      if (answer.isSent) {
        await _deleteRecordedAudioFile(state.recordedAudio);
        _mainCubit.updateSessions();
        _recordAudioDuration = null;
      }

      final List<ChatItem> messages = List.of(state.activeMessages);
      messages.add(answer);

      emit(
        state.copyWith(
          isRecordingAudio: false,
          recordedAudio: answer.isSent ? null : state.recordedAudio,
          activeMessages: messages,
        ),
      );

      deleteAttachedPictures();
      scrollChatDown();
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
      textInputEditingController.clear();
      deleteAttachedPictures();
      scrollChatDown();

      if (answer.isSent) {
        _mainCubit.updateSessions();
      }
    }
  }

  void changeCurrentTabIndex(int newIndex) {
    emit(state.copyWith(currentTabIndex: newIndex));
  }

  void updateSuccessMessage(AppSuccess appSuccess) {
    emit(state.copyWith(appSuccess: appSuccess));
  }

  void clearSuccessMessage() {
    if (state.appSuccess is! EmptySuccess) {
      _counterMessageCleared = state.appSuccess.uiSuccessType ==
          UISuccessType.thisQuestionWillBeReturnedToTheGeneralListAfterCounter;
      emit(state.copyWith(appSuccess: const EmptySuccess()));
    }
  }

  Future<void> _tryStartAnswerSend() async {
    if (await _connectivityService.checkConnection() &&
        !_isStartAnswerSending &&
        chatScreenArguments.publicQuestionId == null &&
        state.questionFromDB?.id != null &&
        state.questionFromDB?.startAnswerDate == null) {
      _isStartAnswerSending = true;
      await _startAnswer(state.questionFromDB!.id!);
      _isStartAnswerSending = false;
    }
  }

  Future<void> _startAnswer(String questionId) async {
    try {
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
          afterShowMessagesInSec = _afterShowMessagesInSec +
              _tillShowMessagesInSec -
              afterTakenInSec;
        }

        if (afterShowMessagesInSec <= 60) {
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
        showInputFieldIfPublic: false,
      ),
    );
  }

  Future<AnswerRequest> _createMediaAnswerRequest() async {
    final Attachment? audioAttachment = await _getAudioAttachment();
    Attachment? pictureAttachment;
    if (state.attachedPictures.isNotEmpty) {
      pictureAttachment = await _getPictureAttachment(0);
    }

    final answerRequest = AnswerRequest(
      questionID: state.questionFromDB?.id,
      ritualID: state.questionFromDB?.ritualID,
      attachments: [
        audioAttachment!,
        if (pictureAttachment != null) pictureAttachment,
      ],
    );

    return answerRequest;
  }

  Future<AnswerRequest> _createTextMediaAnswerRequest() async {
    Attachment? pictureAttachment1 = state.attachedPictures.isNotEmpty
        ? await _getPictureAttachment(0)
        : null;
    Attachment? pictureAttachment2 = state.attachedPictures.length == 2
        ? await _getPictureAttachment(1)
        : null;

    final answerRequest = AnswerRequest(
      questionID: state.questionFromDB?.id,
      ritualID: state.questionFromDB?.ritualID,
      content: textInputEditingController.text.isEmpty
          ? null
          : textInputEditingController.text,
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
      answer = answer.copyWith(
        isAnswer: true,
        type: state.questionFromDB?.type,
        ritualIdentifier: state.questionFromDB?.ritualIdentifier,
      );
      _answerRequest = null;
    } on DioError catch (e) {
      logger.e(e);
      if (!await _connectivityService.checkConnection() ||
          e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        _mainCubit.updateErrorMessage(
            UIError(uiErrorType: UIErrorType.checkYourInternetConnection));
        answer = await _getNotSentAnswer();
      }
    }

    emit(state.copyWith(questionStatus: ChatItemStatusType.answered));
    clearSuccessMessage();
    return answer;
  }

  Future<ChatItem> _getNotSentAnswer() async {
    String? picturePath1 = _getAttachedPicturePath(0);
    String? picturePath2 = _getAttachedPicturePath(1);
    File? recordedAudio = state.recordedAudio;

    final ChatItem answer = ChatItem(
      isAnswer: true,
      isSent: false,
      type: state.questionFromDB?.type,
      ritualIdentifier: state.questionFromDB?.ritualIdentifier,
      content: _answerRequest!.content,
      attachments: [
        if (recordedAudio != null)
          _answerRequest!.attachments![0].copyWith(
            url: recordedAudio.path,
            attachment: null,
          ),
        if (picturePath1 != null)
          _answerRequest!.attachments![recordedAudio == null ? 0 : 1].copyWith(
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

  Future<void> sendAnswerAgain() async {
    try {
      await audioPlayer.stop();

      if (_answerRequest != null) {
        final ChatItem answer = await _repository.sendAnswer(_answerRequest!);
        logger.i('send text response:$answer');
        _answerRequest = null;

        await _deleteRecordedAudioFile(state.recordedAudio);
        _mainCubit.updateSessions();
        _recordAudioDuration = null;

        final List<ChatItem> messages = List.of(state.activeMessages);
        messages.removeLast();
        messages.add(answer.copyWith(
          isAnswer: true,
          type: state.questionFromDB?.type,
          ritualIdentifier: state.questionFromDB?.ritualIdentifier,
        ));

        emit(
          state.copyWith(
            recordedAudio: null,
            activeMessages: messages,
          ),
        );
      }
    } on DioError catch (e) {
      logger.e(e);
      if (!await _connectivityService.checkConnection() ||
          e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        _mainCubit.updateErrorMessage(
            UIError(uiErrorType: UIErrorType.checkYourInternetConnection));
      }
    }
  }

  Future<void> cancelSending() async {
    await audioPlayer.stop();
    await _deleteRecordedAudioFile(state.recordedAudio);

    _answerRequest = null;
    _recordAudioDuration = null;

    final List<ChatItem> messages = List.of(state.activeMessages);
    messages.removeLast();

    emit(
      state.copyWith(
        recordedAudio: null,
        activeMessages: messages,
        questionStatus: state.questionFromDB?.type == ChatItemType.public
            ? ChatItemStatusType.taken
            : ChatItemStatusType.open,
      ),
    );
  }

  String? _getAttachedPicturePath(int n) {
    return state.attachedPictures.length >= n + 1
        ? state.attachedPictures[n].path
        : null;
  }

  Future<Attachment?> _getAudioAttachment() async {
    if (state.recordedAudio == null) {
      return null;
    }

    final List<int> audioBytes = await state.recordedAudio!.readAsBytes();
    final String base64Audio = base64Encode(audioBytes);
    final String? mime = lookupMimeType(state.recordedAudio!.path);
    return Attachment(
        mime: mime,
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

  bool _checkAttachmentSizeIsOk(List<File> images, File? recordedAudio) {
    if (_calculateAttachmentSizeInBytes(images, recordedAudio) <=
        maxAttachmentSizeInBytes) {
      if (_mainCubit.state.appError is UIError &&
          (_mainCubit.state.appError as UIError).uiErrorType ==
              UIErrorType.theMaximumSizeOfTheAttachmentsIsXMb) {
        SchedulerBinding.instance.endOfFrame
            .then((_) => _mainCubit.clearErrorMessage());
      }
      return true;
    } else {
      SchedulerBinding.instance.endOfFrame.then((_) =>
          _mainCubit.updateErrorMessage(UIError(
              uiErrorType: UIErrorType.theMaximumSizeOfTheAttachmentsIsXMb,
              args: [maxAttachmentSizeInMb])));
      return false;
    }
  }

  bool _checkMaxRecordDurationIsOk() {
    if (_recordAudioDuration == null) {
      return true;
    } else {
      return _recordAudioDuration != null &&
          _recordAudioDuration! <= maxRecordDurationInSec;
    }
  }

  int _calculateAttachmentSizeInBytes(List<File> images, File? recordedAudio) {
    int totalSizeInBytes = 0;

    if (images.isNotEmpty) {
      for (File image in images) {
        totalSizeInBytes += image.sizeInBytes;
      }
    }

    if (recordedAudio != null) {
      totalSizeInBytes += recordedAudio.sizeInBytes;
    }

    return totalSizeInBytes;
  }

  bool _checkTextLengthIsOk() {
    final textLength = textInputEditingController.text.length;
    return textLength >= minTextLength && textLength <= maxTextLength;
  }

  bool checkMinRecordDurationIsOk() {
    if (_recordAudioDuration == null) {
      return true;
    } else {
      return _recordAudioDuration != null &&
          _recordAudioDuration! >= minRecordDurationInSec;
    }
  }

  bool canAttachPictureTo({AttachmentType? attachmentType}) {
    return state.attachedPictures.length <
        ((attachmentType != null && attachmentType == AttachmentType.audio)
            ? minAttachedPictures
            : maxAttachedPictures);
  }

  void _scrollTextFieldToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      textInputScrollController
          .jumpTo(textInputScrollController.position.maxScrollExtent);
    });
  }

  bool _checkStatusCode(DioError e) {
    int? statusCode = e.response?.statusCode;
    return statusCode != 401 && statusCode != 428 && statusCode != 451;
  }

  bool _checkRecordedAudioIsOk() {
    return state.recordedAudio != null && checkMinRecordDurationIsOk();
  }

  bool get canRecordAudio =>
      state.attachedPictures.length <= minAttachedPictures &&
      state.isAudioAnswerEnabled == true;

  int get minRecordDurationInSec =>
      answerLimitationContent?.audioTime?.min ??
      AppConstants.minRecordDurationInSec;

  int get maxRecordDurationInSec =>
      answerLimitationContent?.audioTime?.max ??
      AppConstants.maxRecordDurationInSec;

  int get maxRecordDurationInMinutes => maxRecordDurationInSec ~/ 60;

  int get minAttachedPictures =>
      answerLimitationContent?.attachments?.min ?? AppConstants.minAttachments;

  int get maxAttachedPictures =>
      answerLimitationContent?.attachments?.max ?? AppConstants.maxAttachments;

  int get minTextLength =>
      answerLimitationContent?.min ??
      (questionFromDBtype == ChatItemType.ritual
          ? AppConstants.minTextLengthRitual
          : AppConstants.minTextLength);

  int get maxTextLength =>
      answerLimitationContent?.max ??
      (questionFromDBtype == ChatItemType.ritual
          ? AppConstants.maxTextLengthRitual
          : AppConstants.maxTextLength);

  int get maxAttachmentSizeInBytes =>
      answerLimitationContent?.bodySize?.max ??
      AppConstants.maxAttachmentSizeInBytes;

  double get maxAttachmentSizeInMb => maxAttachmentSizeInBytes / 1000000;

  int? get recordAudioDuration => _recordAudioDuration;

  ContentLimitation? get answerLimitationContent =>
      getAnswerLimitationByType(questionFromDBtype)?.content;

  AnswerLimitation? getAnswerLimitationByType(ChatItemType? type) {
    return _answerLimitations.firstWhereOrNull((e) => e.questionType == type);
  }

  ChatItemType? get questionFromDBtype => state.questionFromDB?.type;
}
