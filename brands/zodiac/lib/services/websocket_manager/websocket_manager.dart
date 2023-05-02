import 'package:rxdart/rxdart.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';

abstract class WebSocketManager {
  Stream<List<ChatMessageModel>> get entitiesStream;

  PublishSubject<bool> get endChatTrigger;

  Future connect();

  void close();

  void sendStatus();

  void chatLogin({required int opponentId});

  void reloadMessages({required int opponentId, int? maxId});

  void logoutChat(int chatId);

  void sendDeclineCall({int? opponentId});
}
