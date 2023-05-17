class OfflineSessionEvent {
  final bool isActive;
  final int clientId;
  final Duration? timeout;

  OfflineSessionEvent({
    required this.isActive,
    required this.clientId,
    this.timeout,
  });
}
