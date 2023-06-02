import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/generated/l10n.dart';

enum ZodiacUserStatus {
  online,
  offline,
  busy;

  static ZodiacUserStatus statusFromString(String status) {
    switch (status) {
      case 'ZodiacUserStatus.online':
        return ZodiacUserStatus.online;
      case 'ZodiacUserStatus.busy':
        return ZodiacUserStatus.busy;
      case 'ZodiacUserStatus.offline':
        return ZodiacUserStatus.offline;
      default:
        return ZodiacUserStatus.offline;
    }
  }

  static ZodiacUserStatus statusFromInt(int? i) {
    switch (i) {
      case 1:
        return ZodiacUserStatus.online;
      case 2:
        return ZodiacUserStatus.busy;
      case 3:
        return ZodiacUserStatus.offline;
      default:
        return ZodiacUserStatus.offline;
    }
  }

  int get intFromStatus {
    switch (this) {
      case ZodiacUserStatus.online:
        return 1;
      case ZodiacUserStatus.busy:
        return 2;
      case ZodiacUserStatus.offline:
        return 3;
    }
  }

  Color statusNameColor(BuildContext context) {
    switch (this) {
      case ZodiacUserStatus.online:
        return AppColors.online;
      case ZodiacUserStatus.busy:
        return AppColors.orange;
      case ZodiacUserStatus.offline:
        return Theme.of(context).shadowColor;
    }
  }

  Color statusBadgeColor(BuildContext context) {
    switch (this) {
      case ZodiacUserStatus.online:
        return AppColors.online;
      case ZodiacUserStatus.busy:
        return AppColors.orange;
      case ZodiacUserStatus.offline:
        return Theme.of(context).shadowColor;
    }
  }

  String statusText(BuildContext context) {
    switch (this) {
      case ZodiacUserStatus.online:
        return SZodiac.of(context).onlineZodiac;
      case ZodiacUserStatus.busy:
        return SZodiac.of(context).busyZodiac;
      case ZodiacUserStatus.offline:
        return SZodiac.of(context).offlineZodiac;
    }
  }
}
