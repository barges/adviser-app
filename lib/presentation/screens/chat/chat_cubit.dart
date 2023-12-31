import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/data/models/app_errors/ui_error_type.dart';
import 'package:shared_advisor_interface/data/models/app_success/app_success.dart';
import 'package:shared_advisor_interface/data/models/app_success/ui_success_type.dart';
import 'package:shared_advisor_interface/data/models/chats/answer_limitation.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/chats/content_limitation.dart';
import 'package:shared_advisor_interface/data/models/chats/meta.dart';
import 'package:shared_advisor_interface/data/models/chats/rirual_card_info.dart';
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
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_input_widget.dart';
import 'package:shared_advisor_interface/presentation/services/audio/audio_player_service.dart';
import 'package:shared_advisor_interface/presentation/services/audio/audio_recorder_service.dart';
import 'package:shared_advisor_interface/presentation/services/check_permission_service.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:storage_space/storage_space.dart';
import 'package:uuid/uuid.dart';

import 'chat_state.dart';

const String _recordFileExt = 'm4a';

class ChatCubit extends Cubit<ChatState> {
  final ScrollController activeMessagesScrollController = ScrollController();
  final ScrollController textInputScrollController = ScrollController();
  final SnappingSheetController controller = SnappingSheetController();
  final TextEditingController textInputEditingController =
      TextEditingController();
  final FocusNode textInputFocusNode = FocusNode();
  final GlobalKey textInputKey = GlobalKey();
  final GlobalKey bottomTextAreaKey = GlobalKey();

  final PublishSubject<bool> refreshChatInfoTrigger = PublishSubject();

  GlobalKey? questionGlobalKey;

  final ConnectivityService _connectivityService;

  late final StreamSubscription<bool> _keyboardSubscription;

  final ChatsRepository _repository;
  late final ChatScreenArguments chatScreenArguments;
  final VoidCallback _showErrorAlert;
  final ValueGetter<Future<bool?>> _confirmSendAnswerAlert;
  final ValueGetter<Future<bool?>> _deleteAudioMessageAlert;
  final ValueGetter<Future<bool?>> _recordingIsNotPossibleAlert;
  final MainCubit _mainCubit;
  final AudioPlayerService audioPlayer;
  final AudioRecorderService audioRecorder;
  final CheckPermissionService _checkPermissionService;
  final _uuid = const Uuid();
  int _tillShowMessagesInSec = 0;
  int _afterShowMessagesInSec = 0;
  int _minRecordDurationInSec = 0;
  int _maxRecordDurationInSec = 0;
  int _maxRecordDurationInMinutes = 0;
  int _minTextLength = 0;
  int _maxTextLength = 0;
  int _maxAttachmentSizeInBytes = 0;
  double _maxAttachmentSizeInMb = 0;
  int? _recordAudioDuration;
  AnswerRequest? _answerRequest;
  StreamSubscription<RecorderDisposition>? _recordingProgressSubscription;
  late final StreamSubscription<bool> _appOnPauseSubscription;
  late final StreamSubscription<bool> _stopAudioSubscription;
  late final StreamSubscription<bool> _refreshChatInfoSubscription;

  Timer? _answerTimer;
  bool _counterMessageCleared = false;
  bool _isStartAnswerSending = false;
  int oldTextInputLines = 1;

  static List<AnswerLimitation> _answerLimitations = [];

  ChatCubit(
    this._repository,
    this._connectivityService,
    this._mainCubit,
    this.audioRecorder,
    this.audioPlayer,
    this._checkPermissionService,
    this._showErrorAlert,
    this._confirmSendAnswerAlert,
    this._deleteAudioMessageAlert,
    this._recordingIsNotPossibleAlert,
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
    getData();

    _appOnPauseSubscription = _mainCubit.changeAppLifecycleStream.listen(
      (value) async {
        if (isPublicChat()) {
          _answerTimer?.cancel();
        }
        if (value) {
          if (isPublicChat()) {
            _checkTiming();
          }
        }
        if (!value) {
          if (audioRecorder.isRecording) {
            stopRecordingAudio();
          }
          audioPlayer.pause();
        }
      },
    );

    _keyboardSubscription =
        KeyboardVisibilityController().onChange.listen((bool visible) {
      if (!visible) {
        textInputFocusNode.unfocus();
        emit(state.copyWith(isTextInputCollapsed: true));
      }

      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        if (visible) {
          scrollChatDown();
        }
      }).onError((error, stackTrace) {});
    });

    _stopAudioSubscription = _mainCubit.audioStopTrigger.listen((value) {
      if (audioRecorder.isRecording) {
        stopRecordingAudio();
      }
      audioPlayer.pause();
    });

    _refreshChatInfoSubscription = refreshChatInfoTrigger.listen((value) {
      getData();
    });

    textInputFocusNode.addListener(() {
      final bool isFocused = textInputFocusNode.hasFocus;

      if (!isFocused) {
        setTextInputFocus(false);
      }
      getBottomTextAreaHeight();
    });

    getBottomTextAreaHeight();
  }

  @override
  Future<void> close() async {
    _keyboardSubscription.cancel();
    if (audioRecorder.isRecording) {
      await cancelRecordingAudio();
    }
    _deleteRecordedAudioFile(state.recordedAudio);

    activeMessagesScrollController.dispose();
    _appOnPauseSubscription.cancel();
    _stopAudioSubscription.cancel();

    textInputScrollController.dispose();
    textInputEditingController.dispose();
    textInputFocusNode.dispose();

    audioRecorder.close();
    audioPlayer.dispose();

    _recordingProgressSubscription?.cancel();

    _answerTimer?.cancel();

    _refreshChatInfoSubscription.cancel();

    return super.close();
  }

  void scrollChatDown() {
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      if (activeMessagesScrollController.hasClients) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) =>
            activeMessagesScrollController.animateTo(
                activeMessagesScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear));
      }
    });
  }

  void setTextInputFocus(bool value) {
    emit(state.copyWith(textInputFocused: value));
    if (value) {
      textInputFocusNode.requestFocus();
    }
  }

  void updateTextFieldIsCollapse(bool value) {
    emit(state.copyWith(isTextInputCollapsed: value));
    if (value) {
      _scrollTextFieldToEnd();
    }
  }

  void setStretchedTextField(bool value) {
    emit(state.copyWith(isStretchedTextField: value));
  }

  void updateHiddenInputHeight(double height, double maxHeight) {
    if (height <= maxHeight) {
      emit(state.copyWith(textInputHeight: height));
      if (controller.isAttached && state.isTextInputCollapsed) {
        controller.snapToPosition(SnappingPosition.pixels(
            positionPixels: height + grabbingHeight * 2));
        scrollChatDown();
      }
    } else {
      emit(state.copyWith(textInputHeight: maxHeight));
      if (controller.isAttached && state.isTextInputCollapsed) {
        controller.snapToPosition(SnappingPosition.pixels(
            positionPixels: maxHeight + grabbingHeight * 2));
        scrollChatDown();
      }
    }
  }

  void getBottomTextAreaHeight() {
    WidgetsBinding.instance.endOfFrame.then((value) {
      if (bottomTextAreaKey.currentContext != null) {
        final RenderBox? box =
            bottomTextAreaKey.currentContext!.findRenderObject() as RenderBox?;

        if (box != null) {
          emit(state.copyWith(bottomTextAreaHeight: box.size.height));
        }
      }
    });
  }

  Future<void> getData() async {
    if (needActiveChatTab()) {
      await _getData();
      _setAnswerLimitations();
      if (isPublicChat()) {
        _checkTiming();
      }
    }
  }

  Future<void> _getData() async {
    if (_answerLimitations.isEmpty) {
      await _getAnswerLimitations();
    }

    if (chatScreenArguments.ritualID != null) {
      await _getRituals(chatScreenArguments.ritualID!).then((_) async {
        scrollChatDown();
      });
    } else {
      await _getPublicOrPrivateQuestion();
    }
  }

  Future<void> refreshChatInfo() async {
    refreshChatInfoTrigger.add(true);
  }

  void _setAnswerLimitations() {
    _afterShowMessagesInSec =
        answerLimitationContent?.questionRemindMinutes != null
            ? answerLimitationContent!.questionRemindMinutes! *
                AppConstants.minuteInSec
            : AppConstants.afterShowAnswerTimingMessagesInSec;
    _tillShowMessagesInSec =
        answerLimitationContent?.questionReturnMinutes != null
            ? answerLimitationContent!.questionReturnMinutes! *
                    AppConstants.minuteInSec -
                _afterShowMessagesInSec
            : AppConstants.tillShowAnswerTimingMessagesInSec;

    _minRecordDurationInSec = answerLimitationContent?.audioTime?.min ??
        AppConstants.minRecordDurationInSec;
    _maxRecordDurationInSec = answerLimitationContent?.audioTime?.max ??
        AppConstants.maxRecordDurationInSec;
    _maxRecordDurationInMinutes =
        _maxRecordDurationInSec ~/ AppConstants.minuteInSec;

    _minTextLength = answerLimitationContent?.min ??
        (questionFromDBtype == ChatItemType.ritual
            ? AppConstants.minTextLengthRitual
            : AppConstants.minTextLength);
    _maxTextLength = answerLimitationContent?.max ??
        (questionFromDBtype == ChatItemType.ritual
            ? AppConstants.maxTextLengthRitual
            : AppConstants.maxTextLength);

    _maxAttachmentSizeInBytes = answerLimitationContent?.bodySize?.max ??
        AppConstants.maxAttachmentSizeInBytes;
    _maxAttachmentSizeInMb = _maxAttachmentSizeInBytes /
        (AppConstants.bytesInKilobyte * AppConstants.bytesInKilobyte);
  }

  Future<void> _getAnswerLimitations() async {
    try {
      final AnswerValidationResponse response =
          await _repository.getAnswerValidation();
      _answerLimitations = response.answerLimitations ?? [];
    } catch (e) {
      emit(state.copyWith(refreshEnabled: true));
    }
  }

  void textInputEditingControllerListener() {
    _tryStartAnswerSend();
    emit(
      state.copyWith(
        inputTextLength: textInputEditingController.text.length,
        isSendButtonEnabled:
            (_checkTextLengthIsOk() || state.recordedAudio != null) &&
                _checkAttachmentSizeIsOk(
                    state.attachedPictures, state.recordedAudio),
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
            isAudioAnswerEnabled: question.type != ChatItemType.public,
          ),
        );
      }
      emit(state.copyWith(refreshEnabled: false));
      _refreshChatInfoSubscription.cancel();
    } on DioError catch (e) {
      if (_checkStatusCode(e)) {
        _showErrorAlert();
      }
      emit(state.copyWith(refreshEnabled: true));
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
            isAudioAnswerEnabled: true,
          ),
        );

        scrollChatDown();
      }
      emit(state.copyWith(refreshEnabled: false));
      _refreshChatInfoSubscription.cancel();
    } on DioError catch (e) {
      final int? statusCode = e.response?.statusCode;
      if (statusCode == 404 || statusCode == 409 || statusCode == 400) {
        _showErrorAlert();
      }

      emit(state.copyWith(refreshEnabled: true));
      logger.d(e);
      rethrow;
    }
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
          questionFromDB: question,
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
  }

  Future<void> startRecordingAudio(BuildContext context) async {
    textInputFocusNode.unfocus();
    StorageSpace freeSpace = await getStorageSpace(
      lowOnSpaceThreshold: 0,
      fractionDigits: 1,
    );
    final freeSpaceInMb = freeSpace.free /
        (AppConstants.bytesInKilobyte * AppConstants.bytesInKilobyte);
    if (freeSpaceInMb <= AppConstants.minFreeSpaceInMb) {
      await _recordingIsNotPossibleAlert();
      return;
    }

    _tryStartAnswerSend();

    audioPlayer.stop();

    // ignore: use_build_context_synchronously
    await _checkPermissionService.handlePermission(
        context, PermissionType.audio);

    final isRecordGranted = await Permission.microphone.isGranted;

    if (!isRecordGranted) {
      return;
    }

    final fileName = '${_uuid.v4()}.$_recordFileExt';
    await audioRecorder.startRecorder(fileName);

    _recordingProgressSubscription =
        audioRecorder.onProgress?.listen((e) async {
      _recordAudioDuration = e.duration?.inSeconds;
      if (!_checkMaxRecordDurationIsOk()) {
        stopRecordingAudio();
      }
    });
  }

  Future<void> stopRecordingAudio() async {
    _recordingProgressSubscription?.cancel();
    _recordingProgressSubscription = null;

    String? recordingPath = await audioRecorder.stopRecorder();
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
            args: [_minRecordDurationInSec]));
      } else if (!_checkMaxRecordDurationIsOk()) {
        _mainCubit.updateErrorMessage(UIError(
            uiErrorType: UIErrorType.youVeReachTheXMinuteTimeLimit,
            args: [_maxRecordDurationInMinutes]));
        isSendButtonEnabled = true;
      } else {
        isSendButtonEnabled = true;
      }
    }

    emit(
      state.copyWith(
        recordedAudio: recordedAudio,
        isSendButtonEnabled: isSendButtonEnabled &&
            _checkAttachmentSizeIsOk(state.attachedPictures, recordedAudio),
      ),
    );
  }

  Future<void> cancelRecordingAudio() async {
    _recordingProgressSubscription?.cancel();
    _recordingProgressSubscription = null;
    _recordAudioDuration = null;

    String? recordingPath = await audioRecorder.stopRecorder();
    if (recordingPath != null && recordingPath.isNotEmpty) {
      File recordedAudio = File(recordingPath);
      await _deleteRecordedAudioFile(recordedAudio);
    }

    emit(
      state.copyWith(
        recordedAudio: null,
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
    if (image != null && images.length < AppConstants.maxAttachedPictures) {
      images.add(image);
    } else {
      return;
    }

    emit(
      state.copyWith(
          attachedPictures: images,
          textInputFocused: true,
          isSendButtonEnabled:
              _checkAttachmentSizeIsOk(images, state.recordedAudio) &&
                  (_checkRecordedAudioIsOk() || _checkTextLengthIsOk())),
    );

    textInputFocusNode.requestFocus();

    getBottomTextAreaHeight();
    _scrollTextFieldToEnd();
  }

  void deletePicture(File? image, {bool scrollToEnd = true}) {
    final images = List.of(state.attachedPictures);
    images.remove(image);
    emit(
      state.copyWith(
          attachedPictures: images,
          isSendButtonEnabled:
              _checkAttachmentSizeIsOk(images, state.recordedAudio) &&
                  (_checkRecordedAudioIsOk() || _checkTextLengthIsOk())),
    );

    if (scrollToEnd) {
      _scrollTextFieldToEnd();
    }
    getBottomTextAreaHeight();
  }

  void deleteAttachedPictures() {
    for (var image in state.attachedPictures) {
      deletePicture(image, scrollToEnd: false);
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
        _deleteRecordedAudioFile(state.recordedAudio);
        _mainCubit.updateSessions();
        _recordAudioDuration = null;
      }

      final List<ChatItem> messages = List.of(state.activeMessages);
      messages.add(answer);

      emit(
        state.copyWith(
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
    textInputFocusNode.unfocus();
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

  void goToGallery(RitualCardInfo ritualCardInfo, double initPage) {
    List<String> pictures = [];
    if (ritualCardInfo.leftImage != null) {
      pictures.add(ritualCardInfo.leftImage!);
    }
    if (ritualCardInfo.rightImage != null) {
      pictures.add(ritualCardInfo.rightImage!);
    }
    Get.toNamed(
      AppRoutes.galleryPictures,
      arguments: GalleryPicturesScreenArguments(
        pictures: pictures,
        initPage: initPage,
      ),
    );
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
      emit(
        state.copyWith(
          questionFromDB:
              state.questionFromDB?.copyWith(startAnswerDate: DateTime.now()),
        ),
      );
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

        if (afterShowMessagesInSec <= AppConstants.minuteInSec) {
          _setAnswerIsNotPossible();
        }

        _startTimer(tillShowMessagesInSec, afterShowMessagesInSec);
      } else {
        returnQuestion();
      }
    }
  }

  _startTimer(int tillShowMessagesInSec, int afterShowMessagesInSec) async {
    _answerTimer?.cancel();
    if (state.questionStatus == ChatItemStatusType.taken) {
      _answerTimer = Timer(Duration(seconds: tillShowMessagesInSec), () {
        const tick = Duration(seconds: 1);
        Duration tillEnd = Duration(seconds: afterShowMessagesInSec);

        _answerTimer = Timer.periodic(tick, (_) {
          tillEnd = tillEnd - tick;
          if (tillEnd.inSeconds > AppConstants.minuteInSec) {
            if (!_counterMessageCleared) {
              updateSuccessMessage(UISuccess.withArguments(
                  UISuccessType
                      .thisQuestionWillBeReturnedToTheGeneralListAfterCounter,
                  tillEnd.formatMMSS));
            }
          } else if (tillEnd.inSeconds == AppConstants.minuteInSec) {
            _setAnswerIsNotPossible();
          }
          if (tillEnd.inSeconds == 0) {
            returnQuestion();
            clearSuccessMessage();
          }
        });
      });
    }
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
    ChatItem? answer;
    int? statusCode;
    DioErrorType? errorType;
    try {
      answer = await _repository.sendAnswer(_answerRequest!);
      logger.d('send answer response: $answer');
      answer = answer.copyWith(
        isAnswer: true,
        type: questionFromDBtype,
        ritualIdentifier: state.questionFromDB?.ritualIdentifier,
      );
      _answerTimer?.cancel();
      _answerRequest = null;
    } on DioError catch (e) {
      logger.d(e);
      errorType = e.type;
      if (await _isConnectionProblem(errorType)) {
        _mainCubit.updateErrorMessage(
            UIError(uiErrorType: UIErrorType.checkYourInternetConnection));
        answer = await _getNotSentAnswer();
      }

      statusCode = e.response?.statusCode;
      _handleIfEntityTooLargeError(statusCode);
    }

    if (statusCode != 413 && errorType != DioErrorType.other) {
      emit(state.copyWith(questionStatus: ChatItemStatusType.answered));
    }

    if (statusCode == 409) {
      _showErrorAlert();
    }

    if (answer?.isSent == true) {
      clearSuccessMessage();
    }

    return answer;
  }

  Future<void> sendAnswerAgain() async {
    try {
      await audioPlayer.stop();

      if (_answerRequest != null) {
        final ChatItem answer = await _repository.sendAnswer(_answerRequest!);
        logger.i('send text response:$answer');
        _answerRequest = null;

        final List<ChatItem> messages = List.of(state.activeMessages);
        messages.removeLast();
        messages.add(answer.copyWith(
          isAnswer: true,
          type: questionFromDBtype,
          ritualIdentifier: state.questionFromDB?.ritualIdentifier,
        ));

        _answerTimer?.cancel();
        _recordAudioDuration = null;
        clearSuccessMessage();
        _mainCubit.updateSessions();
        _deleteRecordedAudioFile(state.recordedAudio);

        emit(
          state.copyWith(
              recordedAudio: null,
              activeMessages: messages,
              questionStatus: ChatItemStatusType.answered),
        );
      }
    } on DioError catch (e) {
      logger.d(e);
      if (await _isConnectionProblem(e.type)) {
        _mainCubit.updateErrorMessage(
            UIError(uiErrorType: UIErrorType.checkYourInternetConnection));
      }

      _handleIfEntityTooLargeError(e.response?.statusCode);
    }
  }

  Future<bool> _isConnectionProblem(DioErrorType errorType) async {
    return !await _connectivityService.checkConnection() ||
        errorType == DioErrorType.connectTimeout ||
        errorType == DioErrorType.sendTimeout ||
        errorType == DioErrorType.receiveTimeout;
  }

  _handleIfEntityTooLargeError(int? statusCode) {
    if (statusCode == 413) {
      _mainCubit.updateErrorMessage(UIError(
          uiErrorType: UIErrorType.theMaximumSizeOfTheAttachmentsIsXMb,
          args: [_maxAttachmentSizeInMb.toInt()]));
    }
  }

  Future<ChatItem> _getNotSentAnswer() async {
    String? picturePath1 = _getAttachedPicturePath(0);
    String? picturePath2 = _getAttachedPicturePath(1);
    File? recordedAudio = state.recordedAudio;

    final ChatItem answer = ChatItem(
      isAnswer: true,
      isSent: false,
      type: questionFromDBtype,
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
        questionStatus: questionFromDBtype == ChatItemType.public
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
        _maxAttachmentSizeInBytes) {
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
              args: [_maxAttachmentSizeInMb.toInt()])));
      return false;
    }
  }

  bool _checkMaxRecordDurationIsOk() {
    if (_recordAudioDuration == null) {
      return true;
    } else {
      return _recordAudioDuration != null &&
          _recordAudioDuration! <= _maxRecordDurationInSec;
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
    return textLength >= _minTextLength && textLength <= _maxTextLength;
  }

  bool checkMinRecordDurationIsOk() {
    if (_recordAudioDuration == null) {
      return true;
    } else {
      return _recordAudioDuration != null &&
          _recordAudioDuration! >= _minRecordDurationInSec;
    }
  }

  bool canAttachPictureTo({AttachmentType? attachmentType}) {
    return state.attachedPictures.length <
        ((attachmentType != null && attachmentType == AttachmentType.audio)
            ? AppConstants.minAttachedPictures
            : AppConstants.maxAttachedPictures);
  }

  void _scrollTextFieldToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (textInputScrollController.hasClients) {
        textInputScrollController
            .jumpTo(textInputScrollController.position.maxScrollExtent);
      }
    });
  }

  bool _checkStatusCode(DioError e) {
    int? statusCode = e.response?.statusCode;
    return statusCode == 404 || statusCode == 409;
  }

  bool _checkRecordedAudioIsOk() {
    return state.recordedAudio != null && checkMinRecordDurationIsOk();
  }

  int get minRecordDurationInSec => _minRecordDurationInSec;

  int get maxRecordDurationInMinutes => _maxRecordDurationInMinutes;

  int get minTextLength => _minTextLength;

  int? get recordAudioDuration => _recordAudioDuration;

  ContentLimitation? get answerLimitationContent =>
      getAnswerLimitationByType(questionFromDBtype)?.content;

  AnswerLimitation? getAnswerLimitationByType(ChatItemType? type) {
    return _answerLimitations.firstWhereOrNull((e) => e.questionType == type);
  }

  ChatItemType? get questionFromDBtype => state.questionFromDB?.type;
}
