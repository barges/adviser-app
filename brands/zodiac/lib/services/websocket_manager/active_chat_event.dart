class ActiveChatEvent {
  final bool isActive;
  final int? clientId;

  ActiveChatEvent({
    required this.isActive,
    this.clientId,
  });
}
