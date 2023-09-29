import 'package:rxdart/rxdart.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/chat/enter_room_data.dart';
import 'package:zodiac/data/models/upselling_action/upselling_action_model.dart';
import 'package:zodiac/services/websocket_manager/active_chat_event.dart';
import 'package:zodiac/services/websocket_manager/chat_login_event.dart';
import 'package:zodiac/services/websocket_manager/created_delivered_event.dart';
import 'package:zodiac/services/websocket_manager/message_reaction_created_event.dart';
import 'package:zodiac/services/websocket_manager/offline_session_event.dart';
import 'package:zodiac/services/websocket_manager/paid_free_event.dart';
import 'package:zodiac/services/websocket_manager/room_paused_event.dart';
import 'package:zodiac/services/websocket_manager/send_user_message_event.dart';
import 'package:zodiac/services/websocket_manager/underage_confirm_event.dart';
import 'package:zodiac/services/websocket_manager/update_timer_event.dart';
import 'package:zodiac/services/websocket_manager/upselling_list_event.dart';

enum WebSocketState {
  connected,
  closed;
}

abstract class WebSocketManager {
  Stream<List<ChatMessageModel>> get entitiesStream;

  Stream<ChatMessageModel> get oneMessageStream;

  Stream<CreatedDeliveredEvent> get updateMessageIdStream;

  Stream<CreatedDeliveredEvent> get updateMessageIsDeliveredStream;

  Stream<ActiveChatEvent> get chatIsActiveStream;

  Stream<OfflineSessionEvent> get offlineSessionIsActiveStream;

  Stream<int> get updateMessageIsReadStream;

  Stream<int> get updateWriteStatusStream;

  Stream<EnterRoomData> get enterRoomDataStream;

  PublishSubject<bool> get endChatTrigger;

  Stream<UpdateTimerEvent> get updateChatTimerStream;

  Stream<bool> get stopRoomStream;

  Stream<ChatLoginEvent> get chatLoginStream;

  Stream<UnderageConfirmEvent> get underageConfirmStream;

  Stream<MessageReactionCreatedEvent> get messageReactionCreatedStream;

  Stream<WebSocketState> get webSocketStateStream;

  Stream<PaidFreeEvent> get paidFreeStream;

  Stream<RoomPausedEvent> get roomPausedStream;

  Stream<UpsellingListEvent> get upsellingListStream;

  Stream<SendUserMessageEvent> get sendUserMessageStream;

  Stream<List<UpsellingActionModel>> get upsellingActionsStream;

  WebSocketState get currentState;

  Future connect();

  void close(String reason);

  void sendStatus();

  void chatLogin({
    required int opponentId,
  });

  sendMessageToChat({
    required ChatMessageModel message,
    required String roomId,
    required int opponentId,
  });

  void sendWriteStatus({
    required int opponentId,
    required String roomId,
  });

  void sendReadMessage({
    required int messageId,
    required int opponentId,
  });

  void reloadMessages({
    required int opponentId,
    int? maxId,
  });

  void logoutChat(int chatId);

  void sendDeclineCall({int? opponentId});

  void sendUnreadChats();

  void sendCreateRoom({int? clientId, double? expertFee});

  void sendEndChat({required String roomId});

  void sendUnderageConfirm({required String roomId});

  void sendUnderageReport({required String roomId});

  void sendCloseOfflineSession();

  void sendMessageReaction({
    required String mid,
    required String message,
    required String roomId,
    required int opponentId,
  });

  void addUpdateIdEvent(CreatedDeliveredEvent event);

  void sendUpsellingList({required int chatId});

  void sendUpselling({
    required int chatId,
    required int opponentId,
    String? customCannedMessage,
    String? couponCode,
    int? cannedMessageId,
  });

  void sendUpsellingActions();
}
