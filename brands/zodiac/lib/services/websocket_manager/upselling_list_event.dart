import 'package:zodiac/data/models/canned_message_socket/canned_message_socket_category.dart';

class UpsellingListEvent {
  final List<CannedMessageSocketCategory>? cannedCategories;
  final int opponentId;

  UpsellingListEvent({
    this.cannedCategories,
    required this.opponentId,
  });
}
