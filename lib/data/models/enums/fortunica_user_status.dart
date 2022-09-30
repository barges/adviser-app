import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

enum FortunicaUserStatusEnum {
  @JsonValue("LIVE")
  live,
  @JsonValue("INCOMPLETE")
  incomplete,
  @JsonValue("BLOCKED")
  blocked,
  @JsonValue("LEGALBLOCK")
  legalBlock,
  @JsonValue("OFFLINE")
  offline,
}

extension StatusExt on FortunicaUserStatusEnum {
  String get statusName {
    switch (this) {
      case FortunicaUserStatusEnum.live:
        return 'Live';
      case FortunicaUserStatusEnum.incomplete:
        return 'Incomplete';
      case FortunicaUserStatusEnum.blocked:
        return 'Blocked';
      case FortunicaUserStatusEnum.legalBlock:
        return 'Legal block';
      case FortunicaUserStatusEnum.offline:
        return 'Offline';
    }
  }

  Color get statusColor {
    switch (this) {
      case FortunicaUserStatusEnum.live:
        return AppColors.online;
      case FortunicaUserStatusEnum.incomplete:
      case FortunicaUserStatusEnum.blocked:
      case FortunicaUserStatusEnum.legalBlock:
        return AppColors.error;
      case FortunicaUserStatusEnum.offline:
        return Get.theme.shadowColor;
    }
  }

  Color get statusColorForBadge {
    switch (this) {
      case FortunicaUserStatusEnum.live:
        return AppColors.online;
      case FortunicaUserStatusEnum.incomplete:
      case FortunicaUserStatusEnum.blocked:
      case FortunicaUserStatusEnum.legalBlock:
      case FortunicaUserStatusEnum.offline:
        return Get.theme.shadowColor;
    }
  }
}
