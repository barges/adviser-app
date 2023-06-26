class MessageReactionCreatedEvent {
  final int? id;
  final String? mid;
  final String reaction;
  final int clientId;

  const MessageReactionCreatedEvent({
    this.id,
    this.mid,
    required this.reaction,
    required this.clientId,
  });
}
