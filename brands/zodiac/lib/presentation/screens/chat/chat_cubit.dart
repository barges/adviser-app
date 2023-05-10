import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/chat/enter_room_data.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/data/network/requests/profile_details_request.dart';
import 'package:zodiac/data/network/responses/profile_details_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/chat/chat_state.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_text_input_widget.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';

const Duration _typingIndicatorDuration = Duration(milliseconds: 5000);

class ChatCubit extends Cubit<ChatState> {
  final WebSocketManager _webSocketManager;
  final bool _fromStartingChat;
  final UserData clientData;
  final ZodiacUserRepository _userRepository;
  final double _screenHeight;

  final SnappingSheetController snappingSheetController = SnappingSheetController();
  final TextEditingController textInputEditingController = TextEditingController();
  final ScrollController textInputScrollController = ScrollController();
  final ScrollController messagesScrollController = ScrollController();

  final FocusNode textInputFocusNode = FocusNode();
  final GlobalKey textInputKey = GlobalKey();
  final GlobalKey bottomTextAreaKey = GlobalKey();

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
  late final StreamSubscription<ChatMessageModel> _updateMessageIdSubscription;
  late final StreamSubscription<ChatMessageModel>
      _updateMessageIsDeliveredSubscription;
  late final StreamSubscription<int> _updateMessageIsReadSubscription;
  late final StreamSubscription<int> _updateWriteStatusSubscription;

  late final StreamSubscription<bool> _keyboardSubscription;

  bool triggerOnTextChanged = true;
  bool _isRefresh = false;
  bool _isLoadingMessages = false;

  final List<ChatMessageModel> _messages = [];
  EnterRoomData? enterRoomData;

  ChatCubit(
    this._webSocketManager,
    this._fromStartingChat,
    this.clientData,
    this._userRepository,
    this._screenHeight,
  ) : super(const ChatState()) {
    _messagesSubscription = _webSocketManager.entitiesStream.listen((event) {
      if (_isRefresh) {
        _isRefresh = false;
        _messages.clear();
      }

      _messages.addAll(event);
      _updateMessages(_messages);

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
          chatObserver.standby();
          _updateMessages(_messages);
          if (!event.isOutgoing) {
            _updateWriteStatus(false);
          } else {
            animateToStartChat();
          }
        }
      });
    });

    _updateMessageIdSubscription =
        _webSocketManager.updateMessageIdStream.listen((event) {});

    _updateMessageIsDeliveredSubscription =
        _webSocketManager.updateMessageIsDeliveredStream.listen((event) {});

    _updateWriteStatusSubscription =
        _webSocketManager.updateWriteStatusStream.listen((event) {
      if (event == clientData.id && !state.needShowTypingIndicator) {
        _updateWriteStatus(true);
        Future.delayed(_typingIndicatorDuration)
            .then((value) => _updateWriteStatus(false));
      }
    });

    _updateMessageIsReadSubscription =
        _webSocketManager.updateMessageIsReadStream.listen((event) {
      final int index = _messages.indexWhere((element) => element.id == event);
      if (index > -1) {
        final ChatMessageModel model = _messages[index];
        _messages[index] = model.copyWith(
          isRead: true,
        );
        _updateMessages(_messages);
      }
    });

    _enterRoomDataSubscription =
        _webSocketManager.enterRoomDataStream.listen((event) {
      if (event.userData?.id == clientData.id) {
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
      if(textInputEditingController.text.isNotEmpty){
        emit(state.copyWith(
          inputTextLength: textInputEditingController.text.length,
          isSendButtonEnabled: true,
        ));
      } else {
        emit(state.copyWith(
          inputTextLength: 0,
          isSendButtonEnabled: false,
        ));
      }
      if (triggerOnTextChanged) {
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
      getBottomTextAreaHeight();
    });

    getBottomTextAreaHeight();
    getClientInformation();
  }

  @override
  Future<void> close() {
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
    return super.close();
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
    if(messagesScrollController.hasClients) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        messagesScrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      });
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

  void _updateMessages(List<ChatMessageModel> messages) {
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
}
