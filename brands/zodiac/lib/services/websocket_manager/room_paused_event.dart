class RoomPausedEvent {
  final int opponentId;
  final bool isPaused;

  const RoomPausedEvent({
    required this.opponentId,
    required this.isPaused,
  });
}
