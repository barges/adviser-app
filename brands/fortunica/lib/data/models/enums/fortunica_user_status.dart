import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fortunica/generated/l10n.dart';

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

  String statusName(BuildContext context) {
    switch (this) {
      case FortunicaUserStatus.live:
        return SFortunica.of(context).liveFortunica;
      case FortunicaUserStatus.incomplete:
        return SFortunica.of(context).incompleteFortunica;
      case FortunicaUserStatus.blocked:
        return SFortunica.of(context).blockedFortunica;
      case FortunicaUserStatus.legalBlock:
        return SFortunica.of(context).legalBlockFortunica;
      case FortunicaUserStatus.offline:
        return SFortunica.of(context).offlineFortunica;
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

  String errorText(BuildContext context) {
    switch (this) {
      case FortunicaUserStatus.live:
      case FortunicaUserStatus.blocked:
        return '';
      case FortunicaUserStatus.incomplete:
      case FortunicaUserStatus.legalBlock:
      case FortunicaUserStatus.offline:
        return '${errorTitleText(context)}. ${errorBodyText(context)}';
    }
  }

  String errorTitleText(BuildContext context) {
    switch (this) {
      case FortunicaUserStatus.live:
      case FortunicaUserStatus.blocked:
        return '';
      case FortunicaUserStatus.incomplete:
        return SFortunica.of(context).youReNotLiveOnThePlatformFortunica;
      case FortunicaUserStatus.legalBlock:
        return SFortunica.of(context).youNeedToAcceptTheAdvisorContractFortunica;
      case FortunicaUserStatus.offline:
        return SFortunica.of(context).youReCurrentlyOfflineFortunica;
    }
  }

  String errorBodyText(BuildContext context) {
    switch (this) {
      case FortunicaUserStatus.live:
      case FortunicaUserStatus.blocked:
        return '';
      case FortunicaUserStatus.incomplete:
        return SFortunica
            .of(context)
            .pleaseEnsureYourProfileIsCompletedForAllLanguagesNeedHelpContactYourManagerFortunica;
      case FortunicaUserStatus.legalBlock:
        return SFortunica.of(context).pleaseLoginToTheWebVersionOfYourAccountFortunica;
      case FortunicaUserStatus.offline:
        return SFortunica
            .of(context)
            .changeYourStatusInYourProfileToMakeYourselfVisibleToUsersFortunica;
    }
  }

  String buttonText(BuildContext context) {
    switch (this) {
      case FortunicaUserStatus.live:
      case FortunicaUserStatus.blocked:
        return '';
      case FortunicaUserStatus.incomplete:
        return SFortunica.of(context).completeYourProfileToStartWorkFortunica;
      case FortunicaUserStatus.legalBlock:
      case FortunicaUserStatus.offline:
        return SFortunica.of(context).goToAccountFortunica;
    }
  }
}
