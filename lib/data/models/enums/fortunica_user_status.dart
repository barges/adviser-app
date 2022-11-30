import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  offline,
}

extension StatusExt on FortunicaUserStatus {
  String statusName(BuildContext context) {
    switch (this) {
      case FortunicaUserStatus.live:
        return S.of(context).live;
      case FortunicaUserStatus.incomplete:
        return S.of(context).incomplete;
      case FortunicaUserStatus.blocked:
        return S.of(context).blocked;
      case FortunicaUserStatus.legalBlock:
        return S.of(context).legalBlock;
      case FortunicaUserStatus.offline:
        return S.of(context).offline;
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
        return S.of(context).youReCurrentlyNotLiveOnThePlatform;
      case FortunicaUserStatus.legalBlock:
        return S.of(context).beforeProceedingYouNeedToAcceptContracts;
      case FortunicaUserStatus.offline:
        return S.of(context).youReCurrentlyOfflineOnThePlatform;
    }
  }

  String buttonText(BuildContext context) {
    switch (this) {
      case FortunicaUserStatus.live:
      case FortunicaUserStatus.blocked:
        return '';
      case FortunicaUserStatus.incomplete:
        return S.of(context).completeProfileToStartHelping;
      case FortunicaUserStatus.legalBlock:
      case FortunicaUserStatus.offline:
        return S.of(context).goToAccount;
    }
  }
}
