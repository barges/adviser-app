import 'package:flutter/material.dart';
import 'package:zodiac/generated/l10n.dart';

enum ServiceStatus {
  pending,
  approved,
  rejected;

  static ServiceStatus fromInt(int value) {
    switch (value) {
      case 0:
        return ServiceStatus.pending;
      case 1:
        return ServiceStatus.approved;
      case 2:
        return ServiceStatus.rejected;
      default:
        return ServiceStatus.pending;
    }
  }

  String getTitle(BuildContext context) {
    switch (this) {
      case pending:
        return SZodiac.of(context).pendingZodiac;
      case approved:
        return SZodiac.of(context).approvedZodiac;
      case rejected:
        return SZodiac.of(context).rejectedZodiac;
    }
  }
}
