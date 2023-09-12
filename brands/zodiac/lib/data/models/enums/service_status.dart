import 'package:flutter/material.dart';
import 'package:zodiac/generated/l10n.dart';

enum ServiceStaus {
  pending,
  approved,
  rejected;

  static ServiceStaus fromInt(int value) {
    switch (value) {
      case 0:
        return ServiceStaus.pending;
      case 1:
        return ServiceStaus.approved;
      case 2:
        return ServiceStaus.rejected;
      default:
        return ServiceStaus.pending;
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
