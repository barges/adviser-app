abstract class WebSocketManager {
  Future connect(String authToken, int userId);

  void sendStatus();
}
