import 'package:zodiac/data/models/canned_message/canned_message_category.dart';

class UpsellingListEvent {
  final List<CannedMessageCategory>? cannedCategories;
  final int opponentId;

  UpsellingListEvent({
    this.cannedCategories,
    required this.opponentId,
  });
}
