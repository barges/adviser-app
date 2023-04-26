import 'package:rxdart/rxdart.dart';

abstract class WebSocketManager {
  PublishSubject<bool> get endChatTrigger;

  Future connect();

  void close();

  void sendStatus();

  void sendDeclineCall({int? opponentId});
}
