import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fortunica/generated/l10n.dart';

enum TabsTypes {
  dashboard,
  sessions,
  account;

  String tabName(BuildContext context) {
    switch (this) {
      case TabsTypes.dashboard:
        return SFortunica.of(context).dashboardFortunica;
      case TabsTypes.sessions:
        return SFortunica.of(context).sessionsFortunica;
      case TabsTypes.account:
        return SFortunica.of(context).accountFortunica;
    }
  }

  String get iconPath {
    switch (this) {
      case TabsTypes.dashboard:
        return Assets.vectors.dashboard.path;
      case TabsTypes.sessions:
        return Assets.vectors.sessions.path;
      case TabsTypes.account:
        return Assets.vectors.account.path;
    }
  }
}