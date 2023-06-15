class CreatedDeliveredEvent {
  final String mid;
  final int? id;
  final int clientId;
  final String? path;

  CreatedDeliveredEvent({
    required this.mid,
    required this.clientId,
    this.id,
    this.path,
  });

  @override
  String toString() {
    return 'CreatedDeliveredEvent{mid: $mid, id: $id, clientId: $clientId, path: $path}';
  }
}
