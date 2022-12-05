import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
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
  offline;

  String get statusName {
    switch (this) {
      case FortunicaUserStatus.live:
        return S.current.live;
      case FortunicaUserStatus.incomplete:
        return S.current.incomplete;
      case FortunicaUserStatus.blocked:
        return S.current.blocked;
      case FortunicaUserStatus.legalBlock:
        return S.current.legalBlock;
      case FortunicaUserStatus.offline:
        return S.current.offline;
    }
  }

  Color statusColor(BuildContext context) {
    switch (this) {
      case FortunicaUserStatus.live:
        return AppColors.online;
      case FortunicaUserStatus.incomplete:
      case FortunicaUserStatus.blocked:
      case FortunicaUserStatus.legalBlock:
        return AppColors.error;
      case FortunicaUserStatus.offline:
        return Theme.of(context).shadowColor;
    }
  }

  Color statusColorForBadge(BuildContext context) {
    switch (this) {
      case FortunicaUserStatus.live:
        return AppColors.online;
      case FortunicaUserStatus.incomplete:
      case FortunicaUserStatus.blocked:
      case FortunicaUserStatus.legalBlock:
      case FortunicaUserStatus.offline:
        return Theme.of(context).shadowColor;
    }
  }

  String get errorText {
    switch (this) {
      case FortunicaUserStatus.live:
      case FortunicaUserStatus.blocked:
        return '';
      case FortunicaUserStatus.incomplete:
        return S.current.youReCurrentlyNotLiveOnThePlatform;
      case FortunicaUserStatus.legalBlock:
        return S.current.beforeProceedingYouNeedToAcceptContracts;
      case FortunicaUserStatus.offline:
        return S.current.youReCurrentlyOfflineOnThePlatform;
    }
  }

  String get buttonText {
    switch (this) {
      case FortunicaUserStatus.live:
      case FortunicaUserStatus.blocked:
        return '';
      case FortunicaUserStatus.incomplete:
        return S.current.completeProfileToStartHelping;
      case FortunicaUserStatus.legalBlock:
      case FortunicaUserStatus.offline:
        return S.current.goToAccount;
    }
  }
}
