import 'package:rxdart/rxdart.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/chat/enter_room_data.dart';

abstract class WebSocketManager {
  Stream<List<ChatMessageModel>> get entitiesStream;

  Stream<ChatMessageModel> get oneMessageStream;

  Stream<ChatMessageModel> get updateMessageIdStream;

  Stream<ChatMessageModel> get updateMessageIsDeliveredStream;

  Stream<int> get updateMessageIsReadStream;

  Stream<int> get updateWriteStatusStream;

  ValueStream<EnterRoomData> get enterRoomDataStream;

  PublishSubject<bool> get endChatTrigger;

  Future connect();

  void close();

  void sendStatus();

  void chatLogin({
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
}
