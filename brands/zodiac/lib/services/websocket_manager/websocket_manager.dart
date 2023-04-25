abstract class WebSocketManager {
  Future connect();

  void close();

  void sendStatus();

  void reloadMessages(int userId, {int? maxId});

  void logoutChat(int chatId);
}
