import 'package:zodiac/data/models/chat/chat_message_model.dart';

abstract class WebSocketManager {
  Stream<List<ChatMessageModel>> get entitiesStream;

  Future connect();

  void close();

  void sendStatus();

  void reloadMessages({required int userId, int? maxId});

  void logoutChat(int chatId);
}
