abstract class WebSocketManager {
  Future connect(String authToken, int userId);

  Future<void> close();

  void sendStatus();
}
