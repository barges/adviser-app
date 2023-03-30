import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_screen.dart';
import 'package:zodiac/presentation/screens/home/tabs/articles/articles_screen.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/dashboard_screen.dart';
import 'package:zodiac/presentation/screens/home/tabs/sessions/sessions_screen.dart';

enum TabsTypes {
  dashboard,
  articles,
  sessions,
  account;

  String tabName(BuildContext context) {
    switch (this) {
      case TabsTypes.dashboard:
        return SZodiac.of(context).dashboardZodiac;
      case TabsTypes.articles:
        return SZodiac.of(context).articlesZodiac;
      case TabsTypes.sessions:
        return SZodiac.of(context).sessionsZodiac;
      case TabsTypes.account:
        return SZodiac.of(context).accountZodiac;
    }
  }

  String get iconPath {
    switch (this) {
      case TabsTypes.dashboard:
        return Assets.vectors.dashboard.path;
      case TabsTypes.articles:
        return Assets.vectors.articles.path;
      case TabsTypes.sessions:
        return Assets.vectors.sessions.path;
      case TabsTypes.account:
        return Assets.vectors.account.path;
    }
  }

  Navigator getNavigator({
    required BuildContext context,
  }) {
    switch (this) {
      case TabsTypes.dashboard:
        return Navigator(
            onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                builder: (BuildContext context) => const DashboardScreen()));
      case TabsTypes.articles:
        return Navigator(
            onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                builder: (BuildContext context) => const ArticlesScreen()));
      case TabsTypes.sessions:
        return Navigator(
            onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                builder: (BuildContext context) => const SessionsScreen()));
      case TabsTypes.account:
        return Navigator(
            onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                builder: (BuildContext context) => const AccountScreen()));
    }
  }
}
