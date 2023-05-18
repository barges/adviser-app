class ChatLoginEvent {
  final int chatId;
  final int opponentId;

  ChatLoginEvent({
    required this.chatId,
    required this.opponentId,
  });
}
