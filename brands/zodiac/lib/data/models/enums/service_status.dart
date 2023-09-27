import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
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

  int get toInt {
    switch (this) {
      case pending:
        return 0;
      case approved:
        return 1;
      case rejected:
        return 2;
    }
  }

  Color get labelBackgroundColor {
    switch (this) {
      case pending:
        return AppColors.orange;
      case rejected:
        return AppColors.error;
      case approved:
        return AppColors.online;
    }
  }
}
