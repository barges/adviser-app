class UpdateTimerEvent {
  final Duration value;
  final int clientId;

  UpdateTimerEvent({
    required this.value,
    required this.clientId,
  });
}
