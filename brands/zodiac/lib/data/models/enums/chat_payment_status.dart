import 'package:flutter/material.dart';
import 'package:zodiac/generated/l10n.dart';

enum ChatPaymentStatus {
  paid,
  free;

  static ChatPaymentStatus? statusFromInt(int? statusCode) {
    switch (statusCode) {
      case 0:
        return ChatPaymentStatus.free;
      case 1:
        return ChatPaymentStatus.paid;
      default:
        return null;
    }
  }

  String getLabel(BuildContext context) {
    switch (this) {
      case ChatPaymentStatus.paid:
        return SZodiac.of(context).paidChatZodiac;
      case ChatPaymentStatus.free:
        return SZodiac.of(context).freeChatZodiac;
    }
  }
}
