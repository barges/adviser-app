class MessageReactionCreatedEvent {
  final String id;
  final String reaction;
  final int clientId;

  const MessageReactionCreatedEvent({
    required this.id,
    required this.reaction,
    required this.clientId,
  });
}
