abstract class WebSocketManager {
  Future connect();

  void close();

  void sendStatus();
}
