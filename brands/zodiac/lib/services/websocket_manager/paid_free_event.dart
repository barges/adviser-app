import 'package:zodiac/data/models/enums/chat_payment_status.dart';

class PaidFreeEvent {
  final ChatPaymentStatus status;
  final int opponentId;

  const PaidFreeEvent({
    required this.status,
    required this.opponentId,
  });
}
