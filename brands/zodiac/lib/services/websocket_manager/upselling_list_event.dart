import 'package:zodiac/data/models/canned_message/canned_message_category.dart';
import 'package:zodiac/data/models/coupons/coupons_category.dart';

class UpsellingListEvent {
  final List<CannedMessageCategory>? cannedCategories;
  final List<CouponsCategory>? couponsCategories;
  final int opponentId;
  final int? enabledCouponsCount;

  UpsellingListEvent({
    this.cannedCategories,
    this.couponsCategories,
    required this.opponentId,
    this.enabledCouponsCount,
  });
}
