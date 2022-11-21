import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/articles/articles_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_screen.dart';

enum TabsTypes{
  dashboard,
  articles,
  sessions,
  account
}

extension TabsTypesExt on TabsTypes {
  String get tabName {
    switch (this) {
      case TabsTypes.dashboard:
        return S.current.dashboard;
      case TabsTypes.articles:
        return S.current.articles;
      case TabsTypes.sessions:
        return S.current.sessions;
      case TabsTypes.account:
        return S.current.account;
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

  Navigator getNavigator(BuildContext context) {
    switch (this) {
      case TabsTypes.dashboard:
        return Navigator(
            onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                builder: (BuildContext context) => const DashboardV1Screen()));
      case TabsTypes.articles:
        return  Navigator(
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