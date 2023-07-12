import 'dart:async';
import 'dart:io' hide SocketMessage;

import 'package:collection/collection.dart';
import 'package:disk_space/disk_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/audio/audio_player_service.dart';
import 'package:shared_advisor_interface/services/audio/audio_recorder_service.dart';
import 'package:shared_advisor_interface/services/check_permission_service.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';
import 'package:uuid/uuid.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/app_error/app_error.dart';
import 'package:zodiac/data/models/app_error/ui_error_type.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/chat/enter_room_data.dart';
import 'package:zodiac/data/models/chat/replied_message.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/data/models/enums/chat_message_type.dart';
import 'package:zodiac/data/network/requests/profile_details_request.dart';
import 'package:zodiac/data/network/responses/profile_details_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/base_cubit/base_cubit.dart';
import 'package:zodiac/presentation/screens/chat/chat_state.dart';
import 'package:zodiac/presentation/screens/chat/widgets/text_input_field/chat_text_input_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/upselling_menu_widget.dart';
import 'package:zodiac/services/websocket_manager/created_delivered_event.dart';
import 'package:zodiac/services/websocket_manager/socket_message.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

const Duration _typingIndicatorDuration = Duration(milliseconds: 5000);
const String _recordFileExt = 'm4a';
typedef UnderageConfirmDialog = Future<bool?> Function(String message);

class ChatCubitParams {
  final bool fromStartingChat;
  final UserData clientData;
  final UnderageConfirmDialog underageConfirmDialog;
  final ValueGetter<Future<bool?>> deleteAudioMessageAlert;
  final ValueGetter<Future<bool?>> recordingIsNotPossibleAlert;

  ChatCubitParams({
    required this.fromStartingChat,
    required this.clientData,
    required this.underageConfirmDialog,
    required this.deleteAudioMessageAlert,
    required this.recordingIsNotPossibleAlert,
  });
}

@injectable
class ChatCubit extends BaseCubit<ChatState> {
  final ZodiacCachingManager _cachingManager;
  final WebSocketManager _webSocketManager;
  late final bool _fromStartingChat;
  late final UserData clientData;
  final ZodiacUserRepository _userRepository;
  final MainCubit _mainCubit;
  final ZodiacMainCubit _zodiacMainCubit;
  late final UnderageConfirmDialog _underageConfirmDialog;

  final AudioPlayerService _audioPlayer;
  final AudioRecorderService _audioRecorder;
  final CheckPermissionService _checkPermissionService;
  final _uuid = const Uuid();
  late final ValueGetter<Future<bool?>> _deleteAudioMessageAlert;
  late final ValueGetter<Future<bool?>> _recordingIsNotPossibleAlert;
  StreamSubscription<RecorderDisposition>? _recordingProgressSubscription;

  final SnappingSheetController snappingSheetController =
      SnappingSheetController();
  final ScrollController textInputScrollController = ScrollController();
  final ScrollController messagesScrollController = ScrollController();

  final FocusNode textInputFocusNode = FocusNode();
  final GlobalKey textInputKey = GlobalKey();
  final GlobalKey repliedMessageGlobalKey = GlobalKey();
  final GlobalKey reactedMessageGlobalKey = GlobalKey();

  final PublishSubject<double> _showDownButtonStream = PublishSubject();

  late final ListObserverController observerController =
      ListObserverController(controller: messagesScrollController)
        ..cacheJumpIndexOffset = false;

  late final ChatScrollObserver chatObserver =
      ChatScrollObserver(observerController)..fixedPositionOffset = 48.0;

  StreamSubscription<ChatMessageModel>? _oneMessageSubscription;

  bool triggerOnTextChanged = true;
  bool _isRefresh = false;
  bool _isLoadingMessages = false;

  final List<ChatMessageModel> _messages = [];
  EnterRoomData? enterRoomData;

  Timer? _chatTimer;
  Timer? _offlineSessionTimer;

  int? _chatId;

  int? _recordAudioDuration;

  ChatCubit(
    @factoryParam ChatCubitParams chatCubitParams,
    this._cachingManager,
    this._webSocketManager,
    this._userRepository,
    this._mainCubit,
    this._zodiacMainCubit,
    this._checkPermissionService,
    this._audioPlayer,
    this._audioRecorder,
  ) : super(const ChatState()) {
    _fromStartingChat = chatCubitParams.fromStartingChat;
    clientData = chatCubitParams.clientData;
    _underageConfirmDialog = chatCubitParams.underageConfirmDialog;
    _deleteAudioMessageAlert = chatCubitParams.deleteAudioMessageAlert;
    _recordingIsNotPossibleAlert = chatCubitParams.recordingIsNotPossibleAlert;

    addListener(_webSocketManager.entitiesStream.listen((event) {
      List<ChatMessageModel> messagesNotDelivered = [];
      if (_isRefresh) {
        messagesNotDelivered =
            _messages.where((element) => !element.isDelivered).toList();

        _isRefresh = false;
        _messages.clear();
      }

      _messages.addAll(event);
      if (messagesNotDelivered.isNotEmpty) {
        _messages.insertAll(0, messagesNotDelivered);
      }
      _updateMessages();

      if (event.length == 50) {
        _isLoadingMessages = false;
      }

      _oneMessageSubscription ??=
          _webSocketManager.oneMessageStream.listen((event) {
        bool contains = _messages.any((element) =>
            element.id == event.id ||
            (event.mid != null && element.mid == event.mid));
        if (!contains) {
          _messages.insert(0, event);
          if (state.needShowDownButton) {
            chatObserver.standby();
          }
          _updateMessages();
          if (!event.isOutgoing) {
            _updateWriteStatus(false);
          }
        }
      });
    }));

    addListener(_webSocketManager.updateMessageIdStream.listen((event) {
      if (clientData.id == event.clientId) {
        final int index =
            _messages.indexWhere((element) => element.mid == event.mid);
        if (index > -1) {
          final ChatMessageModel model = _messages[index];
          _messages[index] = model.copyWith(
            id: event.id,
          );
          _updateMessages();
        }
      }
    }));

    addListener(
        _webSocketManager.updateMessageIsDeliveredStream.listen((event) {
      _updateMessageIsDelivered(event);
    }));

    addListener(
        _webSocketManager.updateMessageIsReadStream.distinct().listen((event) {
      final int index = _messages.indexWhere((element) => element.id == event);
      if (index > -1) {
        final ChatMessageModel model = _messages[index];
        _messages[index] = model.copyWith(
          isRead: true,
        );
        _updateMessages();
      }
    }));

    addListener(_webSocketManager.updateWriteStatusStream.listen((event) {
      if (event == clientData.id && !state.needShowTypingIndicator) {
        _updateWriteStatus(true);
        Future.delayed(_typingIndicatorDuration)
            .then((value) => _updateWriteStatus(false));
      }
    }));

    addListener(_webSocketManager.chatIsActiveStream.listen((event) {
      if (event.clientId == clientData.id) {
        emit(state.copyWith(
            chatIsActive: event.isActive, shouldShowInput: event.isActive));
        if (!event.isActive) {
          _chatTimer?.cancel();
          emit(state.copyWith(chatTimerValue: null, reactionMessageId: null));
        }
        if (event.isActive) {
          _stopOfflineSession();
          final String? helloMessage = enterRoomData?.expertData?.helloMessage;
          if (helloMessage?.isNotEmpty == true) {
            sendMessageToChat(text: helloMessage!);
          }
        }
      }
    }));

    addListener(_webSocketManager.offlineSessionIsActiveStream.listen((event) {
      if (event.clientId == clientData.id) {
        emit(state.copyWith(
            offlineSessionIsActive: event.isActive, isVisibleTextField: true));
        if (event.timeout != null && event.isActive) {
          emit(state.copyWith(
              showOfflineSessionsMessage: true,
              offlineSessionTimerValue: event.timeout));
          _offlineSessionTimer?.cancel();
          _offlineSessionTimer =
              Timer.periodic(const Duration(seconds: 1), (timer) {
            if (state.offlineSessionTimerValue?.inSeconds == 0) {
              emit(state.copyWith(showOfflineSessionsMessage: false));
              _offlineSessionTimer?.cancel();
            }
            emit(state.copyWith(
                offlineSessionTimerValue: Duration(
                    seconds:
                        (state.offlineSessionTimerValue?.inSeconds ?? 0) - 1)));
          });
        } else if (!event.isActive) {
          _stopOfflineSession();
          _cancelOrDeleteRecordedAudio();
        }
      }
    }));

    addListener(_webSocketManager.enterRoomDataStream.listen((event) {
      if (event.userData?.id == clientData.id) {
        _isRefresh = true;
        enterRoomData = event;
        emit(state.copyWith(chatIsActive: true));
      }
    }));

    if (!_fromStartingChat) {
      _webSocketManager.chatLogin(opponentId: clientData.id ?? 0);
      emit(state.copyWith(upsellingMenuOpened: true));
    }

    addListener(_showDownButtonStream
        .debounceTime(const Duration(milliseconds: 300))
        .listen((event) {
      emit(
        state.copyWith(
          needShowDownButton: event > 48.0 ? true : false,
        ),
      );
    }));

    addListener(_mainCubit.changeAppLifecycleStream.listen(
      (value) async {
        if (!value) {
          if (_audioRecorder.isRecording) {
            stopRecordingAudio();
          }
          _audioPlayer.pause();
        }
      },
    ));

    addListener(_mainCubit.audioStopTrigger.listen((value) {
      if (_audioRecorder.isRecording) {
        stopRecordingAudio();
      }
      _audioPlayer.pause();
    }));

    messagesScrollController.addListener(() {
      _showDownButtonStream.add(messagesScrollController.position.pixels);

      if (messagesScrollController.position.extentAfter <= 400) {
        if (!_isLoadingMessages) {
          _isLoadingMessages = true;
          final int? maxId = _messages.lastOrNull?.id;
          maxId.let((id) {
            getMessageWithPagination(maxId: maxId);
          });
        }
      }
    });

    addListener(KeyboardVisibilityController().onChange.listen((bool visible) {
      if (!visible) {
        textInputFocusNode.unfocus();
        emit(state.copyWith(isTextInputCollapsed: true));
      }

      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        emit(state.copyWith(keyboardOpened: !state.keyboardOpened));
      }).onError((error, stackTrace) {});
    }));

    textInputFocusNode.addListener(() {
      final bool isFocused = textInputFocusNode.hasFocus;

      if (!isFocused) {
        setTextInputFocus(false);
      }
    });

    addListener(_webSocketManager.updateChatTimerStream.listen(
      (event) {
        if (event.clientId == clientData.id) {
          emit(state.copyWith(isChatReconnecting: false));
          if (state.chatTimerValue?.inSeconds != event.value.inSeconds) {
            _chatTimer?.cancel();
            emit(state.copyWith(chatTimerValue: event.value));
            _chatTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
              emit(state.copyWith(
                  chatTimerValue: Duration(
                      seconds: (state.chatTimerValue?.inSeconds ?? 0) + 1)));
            });
          }
        }
      },
    ));

    addListener(_webSocketManager.stopRoomStream.listen(
      (event) => emit(state.copyWith(isChatReconnecting: true)),
    ));

    addListener(_webSocketManager.chatLoginStream.listen(
      (event) {
        if (clientData.id == event.opponentId) {
          _chatId = event.chatId;
          _webSocketManager.sendUpsellingList(chatId: _chatId!);
        }
      },
    ));

    addListener(_webSocketManager.underageConfirmStream.listen((event) async {
      if (event.opponentId == clientData.id) {
        bool? reportConfirmed = await _underageConfirmDialog(event.message);

        if (reportConfirmed == true) {
          final String? roomId = enterRoomData?.roomData?.id;
          if (roomId != null) {
            _webSocketManager.sendUnderageReport(roomId: roomId);
          }
        }
      }
    }));

    addListener(_webSocketManager.webSocketStateStream.listen(
      (event) {
        if (event == WebSocketState.connected) {
          if (state.offlineSessionIsActive) {
            closeOfflineSession();
          } else if (!state.chatIsActive) {
            _webSocketManager.chatLogin(opponentId: clientData.id ?? 0);
            emit(state.copyWith(isChatReconnecting: false));
          } else {
            _isRefresh = true;
            emit(state.copyWith(chatIsActive: false, chatTimerValue: null));
            _chatTimer?.cancel();
          }
        }
        if (event == WebSocketState.closed) {
          emit(state.copyWith(isChatReconnecting: true));
        }
      },
    ));

    addListener(_webSocketManager.paidFreeStream.listen((event) {
      if (event.opponentId == clientData.id) {
        emit(state.copyWith(chatPaymentStatus: event.status));
      }
    }));

    addListener(_audioRecorder.stateStream.listen((e) async {
      if (e.state == SoundRecorderState.isRecording) {
        emit(state.copyWith(
          recordingDuration: const Duration(),
        ));

        _recordingProgressSubscription =
            _audioRecorder.onProgress?.listen((e) async {
          emit(state.copyWith(
            recordingDuration: e.duration ?? const Duration(),
          ));
        });
      } else {
        _recordingProgressSubscription?.cancel();
      }

      emit(state.copyWith(
        isRecording: e.state == SoundRecorderState.isRecording,
      ));
    }));

    addListener(_webSocketManager.roomPausedStream.listen((event) {
      if (event.opponentId == clientData.id) {
        if (event.isPaused) {
          _chatTimer?.cancel();
        }
        emit(state.copyWith(isVisibleTextField: !event.isPaused));
      }
    }));

    addListener(_webSocketManager.messageReactionCreatedStream.listen((event) {
      if (event.clientId == clientData.id) {
        int index = _messages.indexWhere(
            (element) => element.id == event.id || element.mid == event.mid);
        _messages[index] = _messages[index].copyWith(reaction: event.reaction);
        _updateMessages();
      }
    }));

    addListener(_webSocketManager.upsellingListStream.listen((event) {
      if (event.opponentId == clientData.id) {
        List<UpsellingMenuType> enabledUpsellingItems =
            List.of(state.enabledMenuItems);
        if (event.cannedCategories != null &&
            !enabledUpsellingItems.contains(UpsellingMenuType.canned)) {
          enabledUpsellingItems.add(UpsellingMenuType.canned);
        }
        emit(state.copyWith(
            cannedMessageCategories: event.cannedCategories,
            enabledMenuItems: enabledUpsellingItems));
      }
    }));

    getClientInformation();
  }

  @override
  Future<void> close() async {
    textInputScrollController.dispose();
    messagesScrollController.dispose();

    textInputFocusNode.dispose();

    _showDownButtonStream.close();

    _chatTimer?.cancel();
    _offlineSessionTimer?.cancel();

    _oneMessageSubscription?.cancel();
    _recordingProgressSubscription?.cancel();

    _audioRecorder.close();
    _audioPlayer.dispose();

    return super.close();
  }

  int? get recordAudioDuration => _recordAudioDuration;

  AudioPlayerService get audioPlayer => _audioPlayer;

  AudioRecorderService get audioRecorder => _audioRecorder;

  void sendMessageToChat({required String text}) {
    RepliedMessage? repliedMessage;
    final ChatMessageModel? repliedMessageModel = state.repliedMessage;

    repliedMessageModel?.let((model) {
      repliedMessage = RepliedMessage(
        type: model.type,
        text: model.message,
        repliedUserName: model.authorName,
      );
    });

    final ChatMessageModel chatMessageModel = ChatMessageModel(
      utc: DateTime.now().toUtc(),
      type: ChatMessageType.simple,
      isOutgoing: true,
      isDelivered: false,
      mid: _generateMessageId(),
      message: text,
      repliedMessage: repliedMessage,
      repliedMessageId: state.repliedMessage?.id,
    );
    if (state.needShowDownButton) {
      animateToStartChat();
    }
    _messages.insert(0, chatMessageModel);
    _updateMessages();
    setRepliedMessage();
    _webSocketManager.sendMessageToChat(
      message: chatMessageModel,
      roomId: enterRoomData?.roomData?.id ?? '',
      opponentId: clientData.id ?? 0,
    );
  }

  void sendWriteStatus() {
    if (triggerOnTextChanged) {
      triggerOnTextChanged = false;
      Future.delayed(_typingIndicatorDuration)
          .then((value) => triggerOnTextChanged = true);
      _webSocketManager.sendWriteStatus(
          opponentId: clientData.id ?? 0,
          roomId: enterRoomData?.roomData?.id ?? '');
    }
  }

  void _stopOfflineSession() {
    emit(state.copyWith(
      showOfflineSessionsMessage: false,
      offlineSessionIsActive: false,
      isVisibleTextField: true,
    ));
    _offlineSessionTimer?.cancel();
  }

  setRepliedMessage({
    ChatMessageModel? repliedMessage,
  }) {
    emit(state.copyWith(repliedMessage: repliedMessage));
  }

  void updateInputTextInfo(int textLength, bool isEnabled) {
    emit(state.copyWith(
      inputTextLength: textLength,
      isSendButtonEnabled: isEnabled,
    ));
  }

  void sendReadMessage(int? messageId) {
    _webSocketManager.sendReadMessage(
      messageId: messageId ?? 0,
      opponentId: clientData.id ?? 0,
    );
  }

  void getMessageWithPagination({int? maxId}) {
    _webSocketManager.reloadMessages(
      opponentId: clientData.id ?? 0,
      maxId: maxId,
    );
  }

  Future<void> getClientInformation() async {
    if (clientData.id != null) {
      final ProfileDetailsResponse response = await _userRepository
          .getProfileDetails(ProfileDetailsRequest(userId: clientData.id!));
      if (response.status == true) {
        emit(state.copyWith(clientInformation: response.result));
      }
    }
  }

  void updateHiddenInputHeight(double height, double maxHeight) {
    final double repliedHeight =
        state.repliedMessage != null ? repliedMessageHeight / 2 : 0.0;

    if (height <= maxHeight) {
      emit(state.copyWith(textInputHeight: height));
      if (snappingSheetController.isAttached && state.isTextInputCollapsed) {
        try {
          snappingSheetController.snapToPosition(
            SnappingPosition.pixels(
              positionPixels: height + constGrabbingHeight * 2 + repliedHeight,
            ),
          );
        } catch (e) {
          logger.d('method -> updateHiddenInputHeight in ChatCubit: \n$e');
        }
      }
    } else {
      emit(state.copyWith(textInputHeight: maxHeight));
      if (snappingSheetController.isAttached && state.isTextInputCollapsed) {
        snappingSheetController.snapToPosition(
          SnappingPosition.pixels(
            positionPixels: maxHeight + constGrabbingHeight * 2 + repliedHeight,
          ),
        );
      }
    }
  }

  void changeClientInformationWidgetOpened() {
    emit(state.copyWith(
        clientInformationWidgetOpened: !state.clientInformationWidgetOpened));
  }

  void animateToStartChat() {
    if (messagesScrollController.hasClients) {
      messagesScrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
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

  Future<void> startRecordingAudio(BuildContext context) async {
    textInputFocusNode.unfocus();

    final freeSpaceInMb = await DiskSpace.getFreeDiskSpace ?? double.infinity;
    if (freeSpaceInMb <= AppConstants.minFreeSpaceInMb) {
      await _recordingIsNotPossibleAlert();
      return;
    }

    _audioPlayer.stop();

    // ignore: use_build_context_synchronously
    await _checkPermissionService.handlePermission(
        context, PermissionType.audio);

    final isRecordGranted = await Permission.microphone.isGranted;

    if (!isRecordGranted) {
      return;
    }

    final fileName = '${_uuid.v4()}.$_recordFileExt';
    await _audioRecorder.startRecorder(fileName);

    String? recordingPath = await _audioRecorder.getRecordURL(path: fileName);
    File? recordingAudio;
    if (recordingPath != null) {
      recordingAudio = File(recordingPath);
    }

    _recordingProgressSubscription =
        _audioRecorder.onProgress?.listen((e) async {
      _recordAudioDuration = e.duration?.inSeconds;
      if (recordingAudio != null &&
          !_checkMaxRecordLengthIsOk(recordingAudio)) {
        stopRecordingAudio();
        _zodiacMainCubit.updateErrorMessage(UIError(
            uiErrorType: UIErrorType.recordingStoppedBecauseYouReached,
            args: [AppConstants.maxRecordLengthInMb]));
      }
    });
  }

  Future<void> stopRecordingAudio() async {
    _recordingProgressSubscription?.cancel();
    _recordingProgressSubscription = null;

    String? recordingPath = await _audioRecorder.stopRecorder();
    logger.i("recorded audio: $recordingPath");

    File? recordedAudio;
    if (recordingPath != null && recordingPath.isNotEmpty) {
      recordedAudio = File(recordingPath);
      final Metadata metaAudio =
          await MetadataRetriever.fromFile(recordedAudio);
      _recordAudioDuration = (metaAudio.trackDuration ?? 0) ~/ 1000;
    }

    emit(
      state.copyWith(
        recordedAudio: recordedAudio,
        isSendButtonEnabled: recordedAudio != null,
      ),
    );
  }

  Future<void> deleteRecordedAudio() async {
    await _audioPlayer.stop();

    if (await _deleteAudioMessageAlert() == true) {
      await _deleteRecordedAudioFile(state.recordedAudio);
      _recordAudioDuration = null;

      emit(state.copyWith(
        recordedAudio: null,
      ));
    }
  }

  Future<void> cancelRecordingAudio() async {
    _recordingProgressSubscription?.cancel();
    _recordingProgressSubscription = null;
    _recordAudioDuration = null;

    String? recordingPath = await _audioRecorder.stopRecorder();
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

  void _updateMessages() {
    emit(state.copyWith(messages: List.from(_messages)));
  }

  void _updateWriteStatus(bool isWriting) {
    emit(state.copyWith(
      needShowTypingIndicator: isWriting,
    ));
  }

  void _scrollTextFieldToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (textInputScrollController.hasClients) {
        textInputScrollController
            .jumpTo(textInputScrollController.position.maxScrollExtent);
      }
    });
  }

  bool _checkMaxRecordLengthIsOk(File recordingAudio) {
    return recordingAudio.sizeInMb < AppConstants.maxRecordLengthInMb;
  }

  Future<void> _cancelOrDeleteRecordedAudio() async {
    if (_audioRecorder.isRecording) {
      await cancelRecordingAudio();
    } else if (state.recordedAudio != null) {
      await _deleteRecordedAudioFile(state.recordedAudio);
      emit(
        state.copyWith(
          recordedAudio: null,
        ),
      );
    }
  }

  Future<void> _deleteRecordedAudioFile(File? recordedAudio) async {
    if (recordedAudio != null && await recordedAudio.exists()) {
      recordedAudio.deleteSync();
    }
  }

  String _generateMessageId() {
    final expertId = _cachingManager.getUid();
    return SocketMessage.generateMessageId(expertId);
  }

  void updateSessions() {
    _zodiacMainCubit.updateSessions();
  }

  void endChat() {
    if (enterRoomData?.roomData?.id != null) {
      _webSocketManager.sendEndChat(roomId: enterRoomData!.roomData!.id!);
    }
    _cancelOrDeleteRecordedAudio();
  }

  Future<void> sendImage(File image) async {
    bool? shouldSend = await ZodiacBrand().context?.push<bool?>(
          route: ZodiacSendImage(
            image: image,
          ),
        );

    if (shouldSend == true) {
      ChatMessageModel message = ChatMessageModel(
        type: ChatMessageType.image,
        isOutgoing: true,
        utc: DateTime.now().toUtc(),
        fromAdvisor: true,
        mainImage: image.path,
        mid: _generateMessageId(),
        isDelivered: false,
      );

      _messages.insert(0, message);
      _updateMessages();

      logger.d(message);
    }
  }

  Future<void> sendAudio() async {
    await _audioPlayer.stop();

    ChatMessageModel message = ChatMessageModel(
      type: ChatMessageType.audio,
      isOutgoing: true,
      utc: DateTime.now().toUtc(),
      fromAdvisor: true,
      length: _recordAudioDuration,
      path: state.recordedAudio?.path,
      mid: _generateMessageId(),
      isDelivered: false,
    );

    _messages.insert(0, message);
    _updateMessages();

    emit(state.copyWith(
      recordedAudio: null,
    ));

    logger.d(message);
  }

  void closeOfflineSessionsMessage() {
    _offlineSessionTimer?.cancel();
    emit(state.copyWith(showOfflineSessionsMessage: false));
  }

  void logoutChat(BuildContext context) {
    updateSessions();
    if (_chatId != null) {
      _webSocketManager.logoutChat(_chatId!);
    }
    context.popForced();
  }

  void underageConfirm() {
    String? roomId = enterRoomData?.roomData?.id;
    if (roomId != null) {
      _webSocketManager.sendUnderageConfirm(roomId: roomId);
    }
  }

  void closeOfflineSession() {
    _webSocketManager.sendCloseOfflineSession();
    emit(state.copyWith(
      showOfflineSessionsMessage: false,
      offlineSessionIsActive: false,
    ));
    _offlineSessionTimer?.cancel();
  }

  void deleteMessage(String? mid) {
    final ChatMessageModel? model =
        _messages.firstWhereOrNull((element) => element.mid == mid);
    model?.path?.let((that) => _deleteRecordedAudioFile(File(that)));
    _messages.remove(model);
    emit(state.copyWith(messages: List.of(_messages)));
  }

  void closeErrorMessage() {
    _zodiacMainCubit.clearErrorMessage();
  }

  void updateMediaIsDelivered(CreatedDeliveredEvent event) {
    _updateMessageIsDelivered(event);
    event.pathLocal?.let((that) => _deleteRecordedAudioFile(File(that)));
  }

  void _updateMessageIsDelivered(CreatedDeliveredEvent event) {
    if (clientData.id == event.clientId) {
      final int index =
          _messages.indexWhere((element) => element.mid == event.mid);

      if (index > -1) {
        final ChatMessageModel model = _messages[index];
        _messages[index] = model.copyWith(
          isDelivered: true,
          path: event.path,
        );
        _updateMessages();
      }
    }
  }

  void setEmojiPickerOpened(String? id) {
    emit(state.copyWith(reactionMessageId: id));
    Utils.animateToWidget(reactedMessageGlobalKey);
  }

  void sendReaction(String mid, String emoji) {
    _webSocketManager.sendMessageReaction(
        mid: mid,
        message: emoji,
        roomId: enterRoomData?.roomData?.id ?? '',
        opponentId: clientData.id ?? 0);
    setEmojiPickerOpened(null);
  }

  void selectUpsellingMenuItem(UpsellingMenuType type) {
    if (state.selectedUpsellingMenuItem == type) {
      closeUpsellingMenu();
    } else {
      emit(state.copyWith(selectedUpsellingMenuItem: type));
    }
  }

  void closeUpsellingMenu() {
    emit(state.copyWith(selectedUpsellingMenuItem: null));
  }

  void sendUpsellingMessage({
    String? customCannedMessage,
    String? couponCode,
    int? cannedMessageId,
  }) {
    if (_chatId != null && clientData.id != null) {
      _webSocketManager.sendUpselling(
        chatId: _chatId!,
        opponentId: clientData.id!,
        customCannedMessage: customCannedMessage,
        couponCode: couponCode,
        cannedMessageId: cannedMessageId,
      );
      closeUpsellingMenu();
    }
  }

  void setUpsellingMenuOpened() {
    if (state.enabledMenuItems.isNotEmpty) {
      emit(state.copyWith(
          upsellingMenuOpened: !state.upsellingMenuOpened,
          selectedUpsellingMenuItem: null));
    }
  }
}
