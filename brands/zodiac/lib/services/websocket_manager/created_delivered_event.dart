class CreatedDeliveredEvent {
  final String mid;
  final int? id;
  final int clientId;
  final String? path;
  final String? pathLocal;

  CreatedDeliveredEvent({
    required this.mid,
    required this.clientId,
    this.id,
    this.path,
    this.pathLocal,
  });

  @override
  String toString() {
    return 'CreatedDeliveredEvent{mid: $mid, id: $id, clientId: $clientId, path: $path, pathLocal: $pathLocal}';
  }
}
