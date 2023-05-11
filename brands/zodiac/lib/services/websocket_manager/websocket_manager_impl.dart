import 'dart:async';
import 'dart:convert';

import 'package:eventify/eventify.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:web_socket_channel/io.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/chat/call_data.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/chat/enter_room_data.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/my_details_response.dart';
import 'package:zodiac/presentation/screens/starting_chat/starting_chat_screen.dart';
import 'package:zodiac/services/websocket_manager/commands.dart';
import 'package:zodiac/services/websocket_manager/socket_message.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/zodiac.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/zodiac_constants.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

@Singleton(as: WebSocketManager)
class WebSocketManagerImpl implements WebSocketManager {
  final ZodiacCachingManager _zodiacCachingManager;
  final ZodiacMainCubit _zodiacMainCubit;

  final EventEmitter _emitter = EventEmitter();
  final PublishSubject<bool> _endChatTrigger = PublishSubject();

  WebSocketChannel? _channel;
  StreamSubscription? _socketSubscription;

  final PublishSubject<List<ChatMessageModel>> _entitiesStream =
      PublishSubject();

  final PublishSubject<ChatMessageModel> _oneMessageStream = PublishSubject();

  final BehaviorSubject<EnterRoomData> _enterRoomDataStream = BehaviorSubject();

  final PublishSubject<ChatMessageModel> _updateMessageIdStream =
      PublishSubject();
  final PublishSubject<ChatMessageModel> _updateMessageIsDeliveredStream =
      PublishSubject();
  final PublishSubject<int> _chatIsActiveStream = PublishSubject();

  final PublishSubject<int> _updateMessageIsReadStream = PublishSubject();

  final PublishSubject<int> _updateWriteStatusStream = PublishSubject();

  WebSocketManagerImpl(
    this._zodiacMainCubit,
    this._zodiacCachingManager,
  ) {
    //ping-pong
    _emitter.on(Commands.ping, this, (ev, _) => _send(SocketMessage.pong()));

    //event
    _emitter.on(Commands.event, this, (event, _) => _onEvent(event));

    //advisorLogin
    _emitter.on(Commands.expertLogin, this, (ev, _) {});

    //offlineExpert
    _emitter.on(Commands.forceOffline, this, (ev, _) {});

    //afk
    _emitter.on(Commands.afk, this, (event, _) => _onAfk(event));

    //getState
    _emitter.on(Commands.getState, this, (event, _) => _onGetState(event));

    //syncUserInfo
    _emitter.on(
        Commands.syncUserInfo, this, (event, _) => _onSyncUserInfo(event));

    //startCall(chat)
    _emitter.on(Commands.startCall, this, (event, _) => _onStartCall(event));

    //cancelCall(chat)
    _emitter.on(Commands.cancelCall, this, (event, _) => _onCancelCall(event));

    //chatLogin
    _emitter.on(Commands.chatLogin, this, (event, _) => _onChatLogin(event));

    //entities
    _emitter.on(Commands.entities, this, (event, _) => _onEntities(event));

    //createRoom
    _emitter.on(Commands.enterRoom, this, (event, _) => _onEnterRoom(event));

    _emitter.on(
        Commands.declineCall, this, (event, _) => _onDeclineCall(event));

    _emitter.on(Commands.endCall, this, (event, _) => _onEndCall(event));

    //enterRoom
    _emitter.on(Commands.roomLogin, this, (event, _) => _onRoomLogin(event));

    //lastMessages
    _emitter.on(Commands.lastMessages, this, (ev, _) => _onLastMessages());

    //allInRoom
    _emitter.on(Commands.allInRoom, this, (event, _) => _onAllInRoom(event));

    //productList
    _emitter.on(
        Commands.productList, this, (event, _) => _onProductList(event));

    //writeStatus
    _emitter.on(
        Commands.writeStatus, this, (event, _) => _onWriteStatus(event));

    //chatMessage && productMessage && privateMessage
    _emitter.on(Commands.msgCreated, this, (event, _) => _onMsgCreated(event));

    //msgDelivered
    _emitter.on(
        Commands.msgDelivered, this, (event, _) => _onMsgDelivered(event));

    //message
    _emitter.on(Commands.message, this, (event, _) => _onMessage(event));

    //getUnreadChats
    _emitter.on(
        Commands.unreadChats, this, (event, _) => _onUnreadChats(event));

    //readMessage
    _emitter.on(
        Commands.readMessage, this, (event, _) => _onReadMessage(event));

    //underageConfirm
    _emitter.on(Commands.underageConfirm, this,
        (event, _) => _onUnderageConfirm(event));

    //underageReport
    _emitter.on(
        Commands.underageReport, this, (event, _) => _onUnderageReport());

    //saveChat
    _emitter.on(Commands.endChat, this, (event, _) => _onEndChat(event));

    //offlineSessionStart
    _emitter.on(Commands.offlineSessionStart, this,
        (event, _) => _onOfflineSessionStart(event));

    //funcActions
    _emitter.on(
        Commands.funcActions, this, (event, _) => _onFuncActions(event));

    //logouted
    _emitter.on(Commands.logouted, this, (event, _) => _onLogouted(event));

    //stoproom
    _emitter.on(Commands.stoproom, this, (event, _) => _onStoproom(event));

    //startroom
    _emitter.on(Commands.startroom, this, (event, _) => _onStartroom(event));

    //paidfree
    _emitter.on(Commands.paidfree, this, (event, _) => _onPaidfree(event));

    //showBtn
    _emitter.on(Commands.showBtn, this, (event, _) => _onShowBtn(event));

    //roomPaused
    _emitter.on(Commands.roomPaused, this, (event, _) => _onRoomPaused(event));

    //roomUnpaused
    _emitter.on(
        Commands.roomUnpaused, this, (event, _) => _onRoomUnpaused(event));

    //sendUserMessage
    _emitter.on(Commands.sendUserMessage, this,
        (event, _) => _onSendUserMessage(event));
  }

  @override
  Stream<List<ChatMessageModel>> get entitiesStream => _entitiesStream.stream;

  @override
  Stream<ChatMessageModel> get oneMessageStream => _oneMessageStream.stream;

  @override
  Stream<ChatMessageModel> get updateMessageIdStream =>
      _updateMessageIdStream.stream;

  @override
  Stream<ChatMessageModel> get updateMessageIsDeliveredStream =>
      _updateMessageIsDeliveredStream.stream;

  @override
  Stream<int> get chatIsActiveStream =>
      _chatIsActiveStream.stream;

@override
  Stream<int> get updateMessageIsReadStream =>
      _updateMessageIsReadStream.stream;

  @override
  Stream<int> get updateWriteStatusStream => _updateWriteStatusStream.stream;

  @override
  ValueStream<EnterRoomData> get enterRoomDataStream =>
      _enterRoomDataStream.stream;

  @override
  PublishSubject<bool> get endChatTrigger => _endChatTrigger;

  @override
  Future connect() async {
    final String? authToken = _zodiacCachingManager.getUserToken();
    final int? advisorId = _zodiacCachingManager.getUid();

    if (authToken != null && advisorId != null) {
      if (_channel != null) {
        close();
      }
      const host = ZodiacConstants.socketUrlZodiac;

      final url = Uri(
          scheme: "wss",
          host: host,
          path: "/wss",
          queryParameters: {"authToken": authToken});

      logger.d("Socket is connecting ...");
      _channel = IOWebSocketChannel.connect(url);
      _socketSubscription = _channel!.stream.listen((event) {
        final message = SocketMessage.fromJson(json.decode(event));
        if (message.action != Commands.ping &&
            message.action != Commands.syncUserInfo) {
          logger.d("SUB Socket event: $event");
        }
        _emitter.emit(message.action, this, message);
      }, onDone: () {
        logger.d("Socket is closed...");
        _authCheckOnBackend();
      }, onError: (error) {
        logger.d("Socket error: $error");
        connect();
      });
      _onStart(advisorId);
    }
  }

  @override
  void sendStatus() {
    _send(SocketMessage.getUnreadChats());
  }

  @override
  void chatLogin({required int opponentId}) {
    _send(
      SocketMessage.chatLogin(
        id: opponentId,
      ),
    );
  }

  @override
  void sendWriteStatus({required int opponentId, required String roomId}) {
    _send(
      SocketMessage.writeStatus(
        opponentId: opponentId,
        roomId: roomId,
      ),
    );
  }

  @override
  void sendReadMessage({
    required int messageId,
    required int opponentId,
  }) {
    _send(
      SocketMessage.readMessage(
        messageId: messageId,
        opponentId: opponentId,
      ),
    );
    _updateMessageIsReadStream.add(messageId);
  }

  @override
  void reloadMessages({required int opponentId, int? maxId}) {
    _send(
      SocketMessage.entities(
        opponentId: opponentId,
        maxId: maxId,
      ),
    );
  }

  @override
  void logoutChat(int chatId) {
    _send(SocketMessage.chatLogout(
      chatId: chatId,
    ));
  }

  @override
  void sendDeclineCall({int? opponentId}) {
    _send(SocketMessage.declineCall(opponentId: opponentId));
  }

  @override
  void sendUnreadChats() {
    _send(SocketMessage.getUnreadChats());
  }

  @override
  void sendCreateRoom({int? clientId, double? expertFee}) {
    if (clientId != null && expertFee != null) {
      _send(
        SocketMessage.createRoom(
          clientId: clientId,
          expertFee: expertFee,
        ),
      );
    }
  }

  @override
  void close() {
    _socketSubscription?.cancel();
    _channel?.sink.close();
  }

  void endChat() {
    _endChatTrigger.add(true);
    _send(SocketMessage.getUnreadChats());
  }

  Future<void> _authCheckOnBackend() async =>
      Timer(const Duration(seconds: 1), () async {
        final MyDetailsResponse response = await zodiacGetIt
            .get<ZodiacUserRepository>()
            .getMyDetails(AuthorizedRequest());
        if (response.status == true) {
          connect();
        }
      });

  void _send(SocketMessage message) {
    if (message.action != Commands.pong) {
      logger.d('PUB message: ${message.encoded}');
    }
    _channel?.sink.add(message.encoded);
  }

  void _onStart(int userId) {
    _send(SocketMessage.advisorLogin(userId: userId));
    _send(SocketMessage.getState());
  }

  void _onEvent(Event event) {
    final SocketMessage message = (event.eventData as SocketMessage);
    final int messageType = message.params?['type'];
    final String location = message.params?['location'];
    if (messageType == 6 && location == '/logout') {
      final zodiacBrand = ZodiacBrand();
      if (zodiacBrand.isCurrent) {
        zodiacGetIt
            .get<ZodiacCachingManager>()
            .logout()
            .then((_) => zodiacBrand.context?.replaceAll([const ZodiacAuth()]));
      }
    }
  }

  void _onSyncUserInfo(Event event) {
    final SocketMessage message = (event.eventData as SocketMessage);
    final UserBalance userBalance = UserBalance.fromJson(message.params ?? {});
    _zodiacMainCubit.updateUserBalance(userBalance);
  }

  Future<void> _onStartCall(Event event) async {
    final SocketMessage message = (event.eventData as SocketMessage);
    final CallData startCallData = CallData.fromJson(message.params ?? {});
    logger.d(message.params);
    if (ZodiacBrand().context != null) {
      showStartingChat(ZodiacBrand().context!, startCallData);
    }
  }

  void _onCancelCall(Event event) {
    final SocketMessage message = (event.eventData as SocketMessage);
    final CallData cancelCallData = CallData.fromJson(message.params ?? {});
    logger.d(message.params);
    endChat();
  }

  void _onAfk(Event event) {
    ///TODO - If (event.eventData as SocketMessage).params['popup'] != null
    ///show afk popup
  }

  void _onGetState(Event event) {
    ///TODO - Implement onGetState
  }

  void _onChatLogin(Event event) {
    final SocketMessage message = (event.eventData as SocketMessage);
    final int? opponentId = message.params['opponent_id'];
    if (opponentId != null) {
      _send(
        SocketMessage.entities(
          opponentId: opponentId,
        ),
      );
    }
  }

  void _onEntities(Event event) {
    final SocketMessage message = (event.eventData as SocketMessage);
    final List<dynamic> mapList = message.params;
    final List<ChatMessageModel> list = mapList
        .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
        .toList();

    _entitiesStream.add(list);
  }

  void _onEnterRoom(Event event) {
    (event.eventData as SocketMessage).let((data) {
      final EnterRoomData enterRoomData =
          EnterRoomData.fromJson(data.params ?? {});

      chatLogin(opponentId: enterRoomData.userData?.id ?? 0);

      _send(SocketMessage.enterRoom(
        opponentId: enterRoomData.userData?.id ?? 0,
        activeChat: enterRoomData.activeChat,
        roomId: enterRoomData.roomData?.id,
      ));
    });
  }

  void _onDeclineCall(Event event) {
    ///TODO - Implement onDeclineCall
    endChat();
  }

  void _onEndCall(Event event) {
    final SocketMessage message = (event.eventData as SocketMessage);
    final CallData endCallData = CallData.fromJson(message.params ?? {});
    logger.d(message.params);
    endChat();

    ///TODO - Implements onEndCall
  }

  void _onLogouted(Event event) {
    final SocketMessage message = (event.eventData as SocketMessage);
    final CallData logoutedData = CallData.fromJson(message.params ?? {});

    ///TODO - Implements onLogouted
  }

  void _onRoomLogin(Event event) {
    ///TODO - Implements onRoomLogin
  }

  void _onLastMessages() {
    ///TODO - Implements onLastMessages
  }

  void _onAllInRoom(Event event) {
    ///TODO - Implements onAllInRoom
  }

  void _onProductList(Event event) {
    ///TODO - Implements onProductList
  }

  void _onWriteStatus(Event event) {
    (event.eventData as SocketMessage).let((data) {
      (data.opponentId as int).let((id) => _updateWriteStatusStream.add(id));
    });
  }

  void _onMsgCreated(Event event) {
    (event.eventData as SocketMessage).let((data) {
      final message = ChatMessageModel.fromJson(data.params ?? {});
      _updateMessageIdStream.add(message);
    });
  }

  void _onMsgDelivered(Event event) {
    (event.eventData as SocketMessage).let((data) {
      final message = ChatMessageModel.fromJson(data.params ?? {});
      _updateMessageIsDeliveredStream.add(message);
    });
  }

  void _onReadMessage(Event event) {
    (event.eventData as SocketMessage).let((data) {
      (data.params['id'] as int)
          .let((id) => _updateMessageIsReadStream.add(id));
    });
  }

  void _onMessage(Event event) {
    // _zodiacMainCubit.updateSessions();

    (event.eventData as SocketMessage).let((data) {
      _send(SocketMessage.msgDelivered(mid: data.params['mid']));

      final message = ChatMessageModel.fromJson(data.params ?? {});

      int messageType = data.params?['type'];
      switch (messageType) {
        case 3:
          // - Simple message
          break;
        case 4:
          // - Coupon message
          break;
        case 5:
          // - Review message
          break;
        case 6:
          // - Products message
          break;
        case 7:
          // - System message
          break;
        case 8:
          // - Private message
          break;
        case 9:
          // - Tips message
          break;
        case 10:
          // - Image message
          break;
        case 11:
          // - Start chat message
          break;
        case 12:
          // - End chat message
          break;
        case 13:
          // - Start call message
          break;
        case 14:
          // - End call message
          break;
        case 15:
          // - Advisor messages message
          break;
        case 16:
          // - Extend message
          break;
        case 17:
          // - Missed message
          break;
        case 18:
          // - Coupon after session message
          break;
        case 19:
          // - Translated message
          break;
        case 20:
          // - Product list message
          break;
        case 21:
          // - Audio message
          break;
      }

      _oneMessageStream.add(message);
    });

    ///TODO - Implements onMessage
    SocketMessage message = (event.eventData as SocketMessage);
  }

  void _onUnreadChats(Event event) {
    SocketMessage message = (event.eventData as SocketMessage);
    int? count = message.params['count'];
    if (count != null) {
      _zodiacMainCubit.updateUnreadChats(count);
    }
  }

  void _onUnderageConfirm(Event event) {
    ///TODO - Implements onUnderageConfirm
  }

  void _onUnderageReport() {
    ///TODO - Implements onUnderageReport
  }

  void _onEndChat(Event event) {
    ///TODO - Implements onEndChat
    endChat();
  }

  void _onOfflineSessionStart(Event event) {
    ///TODO - Implements onOfflineSessionStart
  }

  void _onFuncActions(Event event) {
    ///TODO - Implements onFuncActions
  }

  void _onStoproom(Event event) {
    ///TODO - Implements onStoproom
  }

  void _onStartroom(Event event) {
    ///TODO - Implements onStartroom
  }

  void _onPaidfree(Event event) {
    ///TODO - Implements onPaidfree
  }

  void _onShowBtn(Event event) {
    ///TODO - Show popup with title from event
    ///if advisor answer is true
    ///call _send(SocketMessage.extendSession(...))
  }

  void _onRoomPaused(Event event) {
    ///TODO - Implements onRoomPaused
  }

  void _onRoomUnpaused(Event event) {
    ///TODO - Implements onRoomUnpaused
  }

  void _onSendUserMessage(Event event) {
    ///TODO - Implements onSendUserMessage
  }
}
