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

  String errorText() {
    switch (this) {
      case FortunicaUserStatusEnum.live:
      case FortunicaUserStatusEnum.blocked:
        return '';
      case FortunicaUserStatusEnum.incomplete:
        return 'You’re currently not live on the platform, platform,'
            ' please make sure you fill out your profile for all languages. '
            'You can contact your Manager if you have questions.';
      case FortunicaUserStatusEnum.legalBlock:
        return 'Before proceeding you need to accept contracts.'
            ' To do so please open the web version of the Advisor Tool';
      case FortunicaUserStatusEnum.offline:
        return 'You\'re currently Offline on the platform,'
            ' you can\'t use the full functionality and are not '
            'visible to users. You can change your status'
            ' to Live in your profile.';
    }
  }

  String buttonText() {
    switch (this) {
      case FortunicaUserStatusEnum.live:
      case FortunicaUserStatusEnum.blocked:
        return '';
      case FortunicaUserStatusEnum.incomplete:
        return 'Complete profile to start helping';
      case FortunicaUserStatusEnum.legalBlock:
        return 'Go to Account';
      case FortunicaUserStatusEnum.offline:
        return 'Go to Account';
    }
  }
}
