import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/articles/articles_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_screen.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

enum TabsTypes {
  dashboard,
  articles,
  sessions,
  account;

  String tabName(BuildContext context) {
    switch (this) {
      case TabsTypes.dashboard:
        return S.of(context).dashboard;
      case TabsTypes.articles:
        return S.of(context).articles;
      case TabsTypes.sessions:
        return S.of(context).sessions;
      case TabsTypes.account:
        return S.of(context).account;
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
                builder: (BuildContext context) => const DashboardV1Screen()));
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
