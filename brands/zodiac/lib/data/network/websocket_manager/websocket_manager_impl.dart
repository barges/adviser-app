import 'dart:async';
import 'dart:convert';

import 'package:eventify/eventify.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/socket_message/commands.dart';
import 'package:zodiac/data/models/socket_message/socket_message.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/data/network/websocket_manager/websocket_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zodiac/zodiac_constants.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

@Injectable(as: WebSocketManager)
class WebSocketManagerImpl implements WebSocketManager {
  WebSocketChannel? _channel;

  final ZodiacMainCubit _zodiacMainCubit;

  final _emitter = EventEmitter();

  WebSocketManagerImpl(this._zodiacMainCubit) {
    //ping-pong
    _emitter.on(Commands.ping, this, (ev, _) => _send(SocketMessage.pong()));

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
    _emitter.on(Commands.msgCreated, this, (ev, _) => _onMsgCreated());

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
  Future connect(String authToken, int userId) async {
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
    _channel = WebSocketChannel.connect(url);
    _channel!.stream.listen((event) {
      logger.d("Socket event: $event");

      final message = SocketMessage.fromJson(json.decode(event));
      _emitter.emit(message.action, this, message);
    }, onDone: () {
      //logger.d("Socket is closed...");
    }, onError: (error) {
      logger.d("Socket error: $error");
      connect(authToken, userId);
    });
    _onStart(userId);
  }

  @override
  void sendStatus() {
    _send(SocketMessage.getUnreadChats());
  }

  void close() => _channel?.sink.close();

  void _send(SocketMessage message) {
    //logger.d("WebSocketManager._send() - message: ${message.encoded}");
    _channel?.sink.add(message.encoded);
  }

  void _onStart(int userId) {
    _send(SocketMessage.advisorLogin(userId: userId));
  }

  void _onSyncUserInfo(Event event) {
    SocketMessage message = (event.eventData as SocketMessage);
    UserBalance userBalance = UserBalance.fromJson(message.params ?? {});
    _zodiacMainCubit.updateUserBalance(userBalance);
  }

  void _onAfk(Event event) {
    ///TODO - If (event.eventData as SocketMessage).params['popup'] != null
    ///show afk popup
  }

  void _onGetState(Event event) {
    ///TODO - Implement onGetState
  }

  void _onChatLogin(Event event) {
    ///TODO - Implement onChatLogin
  }

  void _onEntities(Event event) {
    ///TODO - Implement onEntities
  }

  void _onEnterRoom(Event event) {
    ///TODO - Implement onEnterRoom
  }

  void _onDeclineCall(Event event) {
    ///TODO - Implement onDeclineCall
  }

  void _onEndCall(Event event) {
    ///TODO - Implements onEndCall
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
    ///TODO - Implements onWriteStatus
  }

  void _onMsgCreated() {
    ///TODO - Implements onMsgCreated
  }

  void _onMessage(Event event) {
    _send(SocketMessage.msgDelivered());

    ///TODO - Implements onMessage
    SocketMessage message = (event.eventData as SocketMessage);
    int messageType = message.params?['type'];
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
  }

  void _onUnreadChats(Event event) {
    ///TODO - Implements onUnreadChats
  }

  void _onReadMessage(Event event) {
    ///TODO - Implements onReadMessage
  }

  void _onUnderageConfirm(Event event) {
    ///TODO - Implements onUnderageConfirm
  }

  void _onUnderageReport() {
    ///TODO - Implements onUnderageReport
  }

  void _onEndChat(Event event) {
    ///TODO - Implements onEndChat
  }

  void _onOfflineSessionStart(Event event) {
    ///TODO - Implements onOfflineSessionStart
  }

  void _onFuncActions(Event event) {
    ///TODO - Implements onFuncActions
  }

  void _onLogouted(Event event) {
    ///TODO - Implements onLogouted
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
