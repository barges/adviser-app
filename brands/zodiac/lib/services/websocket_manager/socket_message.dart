import 'dart:convert';

import 'package:zodiac/services/websocket_manager/commands.dart';
import 'package:zodiac/services/websocket_manager/socket_constants.dart';

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

  static SocketMessage advisorLogin({required int userId}) => SocketMessage(
      action: Commands.advisorLogin, params: {SocketConstants.userId: userId});

  static SocketMessage offlineStatus({int status = 0}) => SocketMessage(
      action: Commands.offlineExpert, params: {SocketConstants.status: status});

  static SocketMessage setAfk() => SocketMessage(
      action: Commands.setAfk, params: {SocketConstants.afkTime: 10});

  static SocketMessage getState() =>
      SocketMessage(action: Commands.getState, params: {});

  static SocketMessage chatLogin({required int id}) => SocketMessage(
      action: Commands.chatLogin, params: {SocketConstants.id: id});

  static SocketMessage chatLogout({required int chatId}) => SocketMessage(
      action: Commands.chatLogout, params: {SocketConstants.chatId: chatId});

  static SocketMessage entities({required int opponentId, int? maxId}) =>
      SocketMessage(action: Commands.entities, params: {
        SocketConstants.opponentId: opponentId,
        if (maxId != null)
          'filters': {
            'max_id': maxId,
          }
      });

  static SocketMessage createRoom(
          {required int clientId, required double expertFee}) =>
      SocketMessage(action: Commands.createRoom, params: {
        SocketConstants.userData: {SocketConstants.id: clientId},
        SocketConstants.expertData: {SocketConstants.fee: expertFee},
      });

  static SocketMessage enterRoom(
          {required int opponentId, int? activeChat, String? roomId}) =>
      SocketMessage(action: Commands.enterRoom, params: {
        SocketConstants.activeChat: activeChat,
        SocketConstants.roomId: roomId,
        SocketConstants.opponentId: opponentId,
      });

  static SocketMessage writeStatus(
          {required String roomId, required int opponentId}) =>
      SocketMessage(action: Commands.writeStatus, params: {
        SocketConstants.roomId: roomId,
        SocketConstants.opponentId: opponentId,
      });

  static SocketMessage chatMessage({
    required String message,
    required String roomId,
    required int opponentId,
    required String mid,
    int? repliedMessageId,
  }) =>
      SocketMessage(action: Commands.chatMessage, params: {
        SocketConstants.message: message,
        'view': 0,
        SocketConstants.roomId: roomId,
        SocketConstants.opponentId: opponentId,
        SocketConstants.mid: mid,
        'replied_message_id': repliedMessageId,
      });

  static SocketMessage msgDelivered({String? mid}) => SocketMessage(
        action: Commands.msgDelivered,
        params: mid != null
            ? {
                SocketConstants.mid: mid,
              }
            : null,
      );

  static SocketMessage getUnreadChats() =>
      SocketMessage(action: Commands.getUnreadChats, params: {});

  static SocketMessage readMessage(
          {required int messageId, required int opponentId}) =>
      SocketMessage(action: Commands.readMessage, params: {
        SocketConstants.id: messageId,
        SocketConstants.opponentId: opponentId,
      });

  static SocketMessage underageConfirm({required String roomId}) =>
      SocketMessage(
          action: Commands.underageConfirm,
          params: {SocketConstants.roomId: roomId});

  static SocketMessage underageReport({required String roomId}) =>
      SocketMessage(
          action: Commands.underageReport,
          params: {SocketConstants.roomId: roomId});

  static SocketMessage productMessage({
    required String serviceName,
    required double price,
    required int productId,
    required String roomId,
    required String mid,
  }) =>
      SocketMessage(action: Commands.productMessage, params: {
        SocketConstants.message: serviceName,
        SocketConstants.mid: mid,
        "price": price,
        "product_id": productId,
        SocketConstants.roomId: roomId,
        "view": 0
      });

  static SocketMessage saveChat({required String roomId}) =>
      SocketMessage(action: Commands.saveChat, params: {
        "end_type": 2,
        SocketConstants.roomId: roomId,
      });

  static SocketMessage funcActions({required int opponentId}) => SocketMessage(
      action: Commands.funcActions,
      params: {SocketConstants.opponentId: opponentId});

  static SocketMessage privateMessage({
    required int messageId,
    required int opponentId,
    required String mid,
  }) =>
      SocketMessage(action: Commands.privateMessage, params: {
        SocketConstants.mid: mid,
        SocketConstants.messageId: messageId,
        SocketConstants.opponentId: opponentId
      });

  static SocketMessage extendSession({required String roomId}) => SocketMessage(
      action: Commands.extendSession, params: {SocketConstants.roomId: roomId});

  static SocketMessage sendUserMessage(
          {required int chatId,
          required int messageId,
          required int opponentId}) =>
      SocketMessage(action: Commands.sendUserMessage, params: {
        SocketConstants.chatId: chatId,
        SocketConstants.type: "chat",
        "msg": messageId,
        SocketConstants.opponentId: opponentId,
      });

  static SocketMessage declineCall({int? opponentId}) =>
      SocketMessage(action: Commands.declineCall, params: {
        SocketConstants.message: "",
        SocketConstants.userData: {
          SocketConstants.id: opponentId ?? 0,
        },
      });

  static SocketMessage closeOfflineChat() =>
      SocketMessage(action: Commands.closeOfflineChat);

  static SocketMessage sendMessageReaction({
    required String mid,
    required String message,
    required String roomId,
    required int opponentId,
  }) =>
      SocketMessage(
        action: Commands.sendMessageReaction,
        params: {
          SocketConstants.mid: mid,
          SocketConstants.message: message,
          SocketConstants.roomId: roomId,
          SocketConstants.opponentId: opponentId,
        },
      );

  static SocketMessage upsellingList({required int chatId}) => SocketMessage(
        action: Commands.upsellingList,
        params: {
          SocketConstants.chatId: chatId,
        },
      );

  static SocketMessage sendUpselling({
    required int chatId,
    required int opponentId,
    String? customCannedMessage,
    String? couponCode,
    int? cannedMessageId,
  }) =>
      SocketMessage(action: Commands.sendUpselling, params: {
        SocketConstants.chatId: chatId,
        'custom_msg': customCannedMessage,
        'coupon_code': couponCode,
        SocketConstants.messageId: cannedMessageId,
        SocketConstants.opponentId: opponentId,
      });

  static SocketMessage upsellingActions() =>
      SocketMessage(action: Commands.upsellingActions);
}
