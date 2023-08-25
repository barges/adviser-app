import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/generated/l10n.dart';

enum ApprovalStatus {
  newStatus,
  approved,
  rejected,
  temp;

  static ApprovalStatus? fromJson(int value) {
    switch (value) {
      case 0:
        return ApprovalStatus.newStatus;
      case 1:
        return ApprovalStatus.approved;
      case 2:
        return ApprovalStatus.rejected;
      case 3:
        return ApprovalStatus.temp;
      default:
        return null;
    }
  }

  String? getText(BuildContext context) {
    switch (this) {
      case newStatus:
        return SZodiac.of(context).waitingForApprovalZodiac;
      case rejected:
        return SZodiac.of(context).rejectedZodiac;
      default:
        return null;
    }
  }

  Color get color {
    switch (this) {
      case newStatus:
        return AppColors.orange;
      case rejected:
        return AppColors.error;
      default:
        return Colors.transparent;
    }
  }

  String get iconPath {
    switch (this) {
      case newStatus:
        return Assets.zodiac.vectors.waitingForApprovalIcon.path;
      case rejected:
        return Assets.zodiac.vectors.warningTriangleIcon.path;
      default:
        return '';
    }
  }
}
