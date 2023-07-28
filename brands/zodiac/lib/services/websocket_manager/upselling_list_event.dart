import 'package:zodiac/data/models/canned_message_socket/canned_message_socket_category.dart';
import 'package:zodiac/data/models/coupons/coupons_category.dart';

class UpsellingListEvent {
  final List<CannedMessageSocketCategory>? cannedCategories;
  final List<CouponsCategory>? couponsCategories;
  final int opponentId;

  UpsellingListEvent({
    this.cannedCategories,
    this.couponsCategories,
    required this.opponentId,
  });
}
