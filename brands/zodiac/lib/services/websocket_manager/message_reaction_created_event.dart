class MessageReactionCreatedEvent {
  final String mid;
  final String reaction;
  final int clientId;

  const MessageReactionCreatedEvent({
    required this.mid,
    required this.reaction,
    required this.clientId,
  });
}
