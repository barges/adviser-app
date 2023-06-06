import 'dart:convert';

import 'package:zodiac/services/websocket_manager/commands.dart';

class SocketMessage {
  late String action;
  dynamic params;
  int? opponentId;

  SocketMessage({required this.action, this.params});

  SocketMessage.fromJson(Map<String, dynamic> json) {
    action = json['a'];
    if (json['data'] != null) {
      params = json['data'];
    }
    if (json['opponent_id'] != null) {
      opponentId = json['opponent_id'];
    }
  }

  String get encoded {
    Map<String, dynamic> data = {};
    data['a'] = action;
    data['app'] = 'touch';
    if (params != null) {
      data['data'] = params;
    }
    if (opponentId != null) {
      data['opponent_id'] = opponentId;
    }
    return json.encode(data);
  }

  static String generateMessageId(int? expertId) {
    return '${expertId}_${DateTime.now().millisecondsSinceEpoch / 1000}';
  }

  static SocketMessage pong() => SocketMessage(action: Commands.pong);

  static SocketMessage advisorLogin({required int userId}) =>
      SocketMessage(action: Commands.advisorLogin, params: {'user_id': userId});

  static SocketMessage offlineStatus({int status = 0}) =>
      SocketMessage(action: Commands.offlineExpert, params: {'status': status});

  static SocketMessage setAfk() =>
      SocketMessage(action: Commands.setAfk, params: {'afk_time': 10});

  static SocketMessage getState() =>
      SocketMessage(action: Commands.getState, params: {});

  static SocketMessage chatLogin({required int id}) =>
      SocketMessage(action: Commands.chatLogin, params: {'id': id});

  static SocketMessage chatLogout({required int chatId}) =>
      SocketMessage(action: Commands.chatLogout, params: {'chat_id': chatId});

  static SocketMessage entities({required int opponentId, int? maxId}) =>
      SocketMessage(action: Commands.entities, params: {
        'opponent_id': opponentId,
        if (maxId != null)
          'filters': {
            'max_id': maxId,
          }
      });

  static SocketMessage createRoom(
          {required int clientId, required double expertFee}) =>
      SocketMessage(action: Commands.createRoom, params: {
        'userData': {'id': clientId},
        'expertData': {'fee': expertFee},
      });

  static SocketMessage enterRoom(
          {required int opponentId, int? activeChat, String? roomId}) =>
      SocketMessage(action: Commands.enterRoom, params: {
        'active_chat': activeChat,
        'room_id': roomId,
        'opponent_id': opponentId,
      });

  static SocketMessage writeStatus(
          {required String roomId, required int opponentId}) =>
      SocketMessage(action: Commands.writeStatus, params: {
        'room_id': roomId,
        'opponent_id': opponentId,
      });

  static SocketMessage chatMessage({
    required String message,
    required String roomId,
    required int opponentId,
    required String mid,
  }) =>
      SocketMessage(action: Commands.chatMessage, params: {
        'message': message,
        'view': 0,
        'room_id': roomId,
        'opponent_id': opponentId,
        'mid': mid,
      });

  static SocketMessage msgDelivered({String? mid}) => SocketMessage(
        action: Commands.msgDelivered,
        params: mid != null
            ? {
                'mid': mid,
              }
            : null,
      );

  static SocketMessage getUnreadChats() =>
      SocketMessage(action: Commands.getUnreadChats, params: {});

  static SocketMessage readMessage(
          {required int messageId, required int opponentId}) =>
      SocketMessage(action: Commands.readMessage, params: {
        'id': messageId,
        'opponent_id': opponentId,
      });

  static SocketMessage underageConfirm({required String roomId}) =>
      SocketMessage(
          action: Commands.underageConfirm, params: {'room_id': roomId});

  static SocketMessage underageReport({required String roomId}) =>
      SocketMessage(
          action: Commands.underageReport, params: {'room_id': roomId});

  static SocketMessage productMessage({
    required String serviceName,
    required double price,
    required int productId,
    required String roomId,
    required String mid,
  }) =>
      SocketMessage(action: Commands.productMessage, params: {
        "message": serviceName,
        "mid": mid,
        "price": price,
        "product_id": productId,
        "room_id": roomId,
        "view": 0
      });

  static SocketMessage saveChat({required String roomId}) =>
      SocketMessage(action: Commands.saveChat, params: {
        "end_type": 2,
        "room_id": roomId,
      });

  static SocketMessage funcActions({required int opponentId}) => SocketMessage(
      action: Commands.funcActions, params: {"opponent_id": opponentId});

  static SocketMessage privateMessage({
    required int messageId,
    required int opponentId,
    required String mid,
  }) =>
      SocketMessage(action: Commands.privateMessage, params: {
        "mid": mid,
        "message_id": messageId,
        "opponent_id": opponentId
      });

  static SocketMessage extendSession({required String roomId}) => SocketMessage(
      action: Commands.extendSession, params: {'room_id': roomId});

  static SocketMessage sendUserMessage(
          {required int chatId,
          required int messageId,
          required int opponentId}) =>
      SocketMessage(action: Commands.sendUserMessage, params: {
        "chat_id": chatId,
        "type": "chat",
        "msg": messageId,
        "opponent_id": opponentId,
      });

  static SocketMessage declineCall({int? opponentId}) =>
      SocketMessage(action: Commands.declineCall, params: {
        "message": "",
        "userData": {
          "id": opponentId ?? 0,
        },
      });

  static SocketMessage closeOfflineChat() =>
      SocketMessage(action: Commands.closeOfflineChat);
}
