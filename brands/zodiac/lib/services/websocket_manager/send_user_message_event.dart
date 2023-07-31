class SendUserMessageEvent {
  final int opponentId;
  final bool status;
  final String? message;

  const SendUserMessageEvent({
    required this.opponentId,
    required this.status,
    this.message,
  });
}
