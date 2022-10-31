import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

enum FortunicaUserStatus {
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

extension StatusExt on FortunicaUserStatus {
  String get statusName {
    switch (this) {
      case FortunicaUserStatus.live:
        return 'Live';
      case FortunicaUserStatus.incomplete:
        return 'Incomplete';
      case FortunicaUserStatus.blocked:
        return 'Blocked';
      case FortunicaUserStatus.legalBlock:
        return 'Legal block';
      case FortunicaUserStatus.offline:
        return 'Offline';
    }
  }

  Color get statusColor {
    switch (this) {
      case FortunicaUserStatus.live:
        return AppColors.online;
      case FortunicaUserStatus.incomplete:
      case FortunicaUserStatus.blocked:
      case FortunicaUserStatus.legalBlock:
        return AppColors.error;
      case FortunicaUserStatus.offline:
        return Get.theme.shadowColor;
    }
  }

  Color get statusColorForBadge {
    switch (this) {
      case FortunicaUserStatus.live:
        return AppColors.online;
      case FortunicaUserStatus.incomplete:
      case FortunicaUserStatus.blocked:
      case FortunicaUserStatus.legalBlock:
      case FortunicaUserStatus.offline:
        return Get.theme.shadowColor;
    }
  }

  String errorText() {
    switch (this) {
      case FortunicaUserStatus.live:
      case FortunicaUserStatus.blocked:
        return '';
      case FortunicaUserStatus.incomplete:
        return 'You’re currently not live on the platform, platform,'
            ' please make sure you fill out your profile for all languages. '
            'You can contact your Manager if you have questions.';
      case FortunicaUserStatus.legalBlock:
        return 'Before proceeding you need to accept contracts.'
            ' To do so please open the web version of the Advisor Tool';
      case FortunicaUserStatus.offline:
        return 'You\'re currently Offline on the platform,'
            ' you can\'t use the full functionality and are not '
            'visible to users. You can change your status'
            ' to Live in your profile.';
    }
  }

  String buttonText() {
    switch (this) {
      case FortunicaUserStatus.live:
      case FortunicaUserStatus.blocked:
        return '';
      case FortunicaUserStatus.incomplete:
        return 'Complete profile to start helping';
      case FortunicaUserStatus.legalBlock:
        return 'Go to Account';
      case FortunicaUserStatus.offline:
        return 'Go to Account';
    }
  }
}
