class CreatedDeliveredEvent {
  final String mid;
  final int? id;
  final int clientId;

  CreatedDeliveredEvent({
    required this.mid,
    required this.clientId,
    this.id,
  });

  @override
  String toString() {
    return 'CreatedDeliveredEvent{mid: $mid, id: $id, clientId: $clientId}';
  }
}