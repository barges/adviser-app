import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/chat/enter_room_data.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/data/models/enums/chat_message_type.dart';
import 'package:zodiac/data/network/requests/profile_details_request.dart';
import 'package:zodiac/data/network/responses/profile_details_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/chat/chat_state.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_text_input_widget.dart';
import 'package:zodiac/services/websocket_manager/active_chat_event.dart';
import 'package:zodiac/services/websocket_manager/created_delivered_event.dart';
import 'package:zodiac/services/websocket_manager/offline_session_event.dart';
import 'package:zodiac/services/websocket_manager/update_timer_event.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

const Duration _typingIndicatorDuration = Duration(milliseconds: 5000);

class ChatCubit extends Cubit<ChatState> {
  final ZodiacCachingManager _cachingManager;
  final WebSocketManager _webSocketManager;
  final bool _fromStartingChat;
  final UserData clientData;
  final ZodiacUserRepository _userRepository;
  final ZodiacMainCubit _zodiacMainCubit;
  final double _screenHeight;

  final SnappingSheetController snappingSheetController =
      SnappingSheetController();
  final TextEditingController textInputEditingController =
      TextEditingController();
  final ScrollController textInputScrollController = ScrollController();
  final ScrollController messagesScrollController = ScrollController();

  final FocusNode textInputFocusNode = FocusNode();
  final GlobalKey textInputKey = GlobalKey();

  final PublishSubject<double> _showDownButtonStream = PublishSubject();
  late final StreamSubscription<double> _showDownButtonSubscription;

  late final ListObserverController observerController =
      ListObserverController(controller: messagesScrollController)
        ..cacheJumpIndexOffset = false;

  late final ChatScrollObserver chatObserver =
      ChatScrollObserver(observerController)..fixedPositionOffset = 48.0;

  StreamSubscription<ChatMessageModel>? _oneMessageSubscription;

  late final StreamSubscription<List<ChatMessageModel>> _messagesSubscription;
  late final StreamSubscription<EnterRoomData> _enterRoomDataSubscription;
  late final StreamSubscription<CreatedDeliveredEvent>
      _updateMessageIdSubscription;
  late final StreamSubscription<CreatedDeliveredEvent>
      _updateMessageIsDeliveredSubscription;
  late final StreamSubscription<int> _updateMessageIsReadSubscription;
  late final StreamSubscription<int> _updateWriteStatusSubscription;
  late final StreamSubscription<UpdateTimerEvent> _updateTimerSubscription;
  late final StreamSubscription<bool> _stopRoomSubscription;

  late final StreamSubscription<ActiveChatEvent>
      _updateChatIsActiveSubscription;

  late final StreamSubscription<OfflineSessionEvent>
      _updateOfflineSessionIsActiveSubscription;

  late final StreamSubscription<bool> _keyboardSubscription;

  bool triggerOnTextChanged = true;
  bool _isRefresh = false;
  bool _isLoadingMessages = false;

  final List<ChatMessageModel> _messages = [];
  EnterRoomData? enterRoomData;
  int offlineSessionTimeout = 0;

  Timer? _chatTimer;

  ChatCubit(
    this._cachingManager,
    this._webSocketManager,
    this._fromStartingChat,
    this.clientData,
    this._userRepository,
    this._zodiacMainCubit,
    this._screenHeight,
  ) : super(const ChatState()) {
    _messagesSubscription = _webSocketManager.entitiesStream.listen((event) {
      if (_isRefresh) {
        _isRefresh = false;
        _messages.clear();
      }

      _messages.addAll(event);
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
    });

    _updateMessageIdSubscription =
        _webSocketManager.updateMessageIdStream.listen((event) {
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
    });

    _updateMessageIsDeliveredSubscription =
        _webSocketManager.updateMessageIsDeliveredStream.listen((event) {
      if (clientData.id == event.clientId) {
        final int index =
            _messages.indexWhere((element) => element.mid == event.mid);

        if (index > -1) {
          final ChatMessageModel model = _messages[index];
          logger.d(model);
          _messages[index] = model.copyWith(
            isDelivered: true,
          );
          logger.d(_messages[index]);
          _updateMessages();
        }
      }
    });

    _updateMessageIsReadSubscription =
        _webSocketManager.updateMessageIsReadStream.distinct().listen((event) {
      final int index = _messages.indexWhere((element) => element.id == event);
      if (index > -1) {
        final ChatMessageModel model = _messages[index];
        _messages[index] = model.copyWith(
          isRead: true,
        );
        _updateMessages();
      }
    });

    _updateWriteStatusSubscription =
        _webSocketManager.updateWriteStatusStream.listen((event) {
      if (event == clientData.id && !state.needShowTypingIndicator) {
        _updateWriteStatus(true);
        Future.delayed(_typingIndicatorDuration)
            .then((value) => _updateWriteStatus(false));
      }
    });

    _updateChatIsActiveSubscription =
        _webSocketManager.chatIsActiveStream.listen((event) {
      if (event.clientId == clientData.id) {
        emit(state.copyWith(chatIsActive: event.isActive));
        if (!event.isActive) {
          _chatTimer?.cancel();
          emit(state.copyWith(timerValue: null));
        }
      }
    });

    _updateOfflineSessionIsActiveSubscription =
        _webSocketManager.offlineSessionIsActiveStream.listen((event) {
      if (event.clientId == clientData.id) {
        offlineSessionTimeout = event.timeout ?? 0;
        emit(state.copyWith(offlineSessionIsActive: event.isActive));
      }
    });

    _enterRoomDataSubscription =
        _webSocketManager.enterRoomDataStream.listen((event) {
      if (event.userData?.id == clientData.id) {
        _isRefresh = true;
        enterRoomData = event;
      }
    });

    if (!_fromStartingChat) {
      _webSocketManager.chatLogin(opponentId: clientData.id ?? 0);
    }

    _showDownButtonSubscription = _showDownButtonStream
        .debounceTime(const Duration(milliseconds: 300))
        .listen((event) {
      emit(
        state.copyWith(
          needShowDownButton: event > 48.0 ? true : false,
        ),
      );
    });

    messagesScrollController.addListener(() {
      _showDownButtonStream.add(messagesScrollController.position.pixels);

      if (messagesScrollController.position.extentAfter <= _screenHeight) {
        if (!_isLoadingMessages) {
          _isLoadingMessages = true;
          final int? maxId = _messages.lastOrNull?.id;
          maxId.let((id) {
            getMessageWithPagination(maxId: maxId);
          });
        }
      }
    });

    textInputEditingController.addListener(() {
      final String text = textInputEditingController.text;
      if (text.isNotEmpty) {
        emit(state.copyWith(
          inputTextLength: text.length,
          isSendButtonEnabled: text.trim().isNotEmpty,
        ));
      } else {
        emit(state.copyWith(
          inputTextLength: 0,
          isSendButtonEnabled: false,
        ));
      }
      if (state.chatIsActive && triggerOnTextChanged) {
        triggerOnTextChanged = false;
        Future.delayed(_typingIndicatorDuration)
            .then((value) => triggerOnTextChanged = true);
        _webSocketManager.sendWriteStatus(
            opponentId: clientData.id ?? 0,
            roomId: enterRoomData?.roomData?.id ?? '');
      }
    });

    _keyboardSubscription =
        KeyboardVisibilityController().onChange.listen((bool visible) {
      if (!visible) {
        textInputFocusNode.unfocus();
        emit(state.copyWith(isTextInputCollapsed: true));
      }

      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        emit(state.copyWith(keyboardOpened: !state.keyboardOpened));
      }).onError((error, stackTrace) {});
    });

    textInputFocusNode.addListener(() {
      final bool isFocused = textInputFocusNode.hasFocus;

      if (!isFocused) {
        setTextInputFocus(false);
      }
    });

    _updateTimerSubscription = _webSocketManager.updateTimerStream.listen(
      (event) {
        if (event.clientId == clientData.id) {
          logger.d(
              '${state.timerValue?.inSeconds} ==== ${event.value.inSeconds}');
          emit(state.copyWith(isChatReconnecting: false));
          if (state.timerValue?.inSeconds != event.value.inSeconds) {
            _chatTimer?.cancel();
            emit(state.copyWith(timerValue: event.value));
            _chatTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
              emit(state.copyWith(
                  timerValue: Duration(
                      seconds: (state.timerValue?.inSeconds ?? 0) + 1)));
            });
          }
        }
      },
    );

    _stopRoomSubscription = _webSocketManager.stopRoomStream.listen(
      (event) => emit(state.copyWith(isChatReconnecting: true)),
    );

    getClientInformation();
  }

  @override
  Future<void> close() {
    textInputEditingController.dispose();
    textInputScrollController.dispose();
    messagesScrollController.dispose();
    textInputFocusNode.dispose();
    _messagesSubscription.cancel();
    _oneMessageSubscription?.cancel();
    _enterRoomDataSubscription.cancel();
    _updateMessageIdSubscription.cancel();
    _updateMessageIsDeliveredSubscription.cancel();
    _updateMessageIsReadSubscription.cancel();
    _updateWriteStatusSubscription.cancel();
    _showDownButtonSubscription.cancel();
    _showDownButtonStream.close();
    _keyboardSubscription.cancel();
    _updateChatIsActiveSubscription.cancel();
    _updateOfflineSessionIsActiveSubscription.cancel();
    _updateTimerSubscription.cancel();
    _chatTimer?.cancel();
    _stopRoomSubscription.cancel();
    return super.close();
  }

  void sendMessageToChat() {
    final ChatMessageModel chatMessageModel = ChatMessageModel(
      utc: DateTime.now().toUtc(),
      type: ChatMessageType.simple,
      isOutgoing: true,
      isDelivered: false,
      mid: _generateMessageId(),
      message: textInputEditingController.text.trim(),
    );
    if (state.needShowDownButton) {
      animateToStartChat();
    }
    _messages.insert(0, chatMessageModel);
    _updateMessages();
    textInputEditingController.clear();
    _webSocketManager.sendMessageToChat(
      message: chatMessageModel,
      roomId: enterRoomData?.roomData?.id ?? '',
      opponentId: clientData.id ?? 0,
    );
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
    if (height <= maxHeight) {
      emit(state.copyWith(textInputHeight: height));
      if (snappingSheetController.isAttached && state.isTextInputCollapsed) {
        try {
          snappingSheetController.snapToPosition(SnappingPosition.pixels(
              positionPixels: height + grabbingHeight * 2));
        } catch (e) {
          logger.d('method -> updateHiddenInputHeight in ChatCubit: \n$e');
        }
      }
    } else {
      emit(state.copyWith(textInputHeight: maxHeight));
      if (snappingSheetController.isAttached && state.isTextInputCollapsed) {
        snappingSheetController.snapToPosition(SnappingPosition.pixels(
            positionPixels: maxHeight + grabbingHeight * 2));
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

  String _generateMessageId() {
    final expertId = _cachingManager.getUid();
    return '${expertId}_${DateTime.now().millisecondsSinceEpoch ~/ 1000}';
  }

  void updateSessions() {
    _zodiacMainCubit.updateSessions();
  }

  void endChat() {
    if (enterRoomData?.roomData?.id != null) {
      _webSocketManager.sendEndChat(roomId: enterRoomData!.roomData!.id!);
    }
  }
}
