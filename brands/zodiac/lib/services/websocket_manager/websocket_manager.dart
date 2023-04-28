import 'package:zodiac/data/models/chat/chat_message_model.dart';

import 'package:rxdart/rxdart.dart';

abstract class WebSocketManager {
  Stream<List<ChatMessageModel>> get entitiesStream;

  PublishSubject<bool> get endChatTrigger;

  Future connect();

  void close();

  void sendStatus();

  void reloadMessages({required int userId, int? maxId});

  void logoutChat(int chatId);

  void sendDeclineCall({int? opponentId});
}
