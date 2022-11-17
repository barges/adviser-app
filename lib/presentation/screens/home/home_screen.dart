import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<BottomNavigationBarItem> bottomBarItems = [
      BottomNavigationBarItem(
        icon: Assets.vectors.dashboard.svg(),
        activeIcon: Assets.vectors.dashboard.svg(
          color: theme.primaryColor,
        ),
        label: 'Dashboard',
      ),
      /**
          BottomNavigationBarItem(
          icon: Assets.vectors.articles.svg(),
          activeIcon: Assets.vectors.articles.svg(
          color: theme.primaryColor,
          ),
          label: 'Articles',
          ),
       */
      BottomNavigationBarItem(
        icon: Assets.vectors.chats.svg(),
        activeIcon: Assets.vectors.chats.svg(
          color: theme.primaryColor,
        ),
        label: 'Chats',
      ),
      BottomNavigationBarItem(
        icon: Assets.vectors.account.svg(),
        activeIcon: Assets.vectors.account.svg(
          color: theme.primaryColor,
        ),
        label: 'Account',
      ),
    ];

    return BlocProvider(
      create: (_) => HomeCubit(
        cacheManager: getIt.get<CachingManager>(),
        context: context,
        accountTabIndex: bottomBarItems.length - 1,
      ),
      child: Builder(builder: (context) {
        final HomeCubit cubit = context.read<HomeCubit>();
        final int tabPositionIndex =
            context.select((HomeCubit cubit) => cubit.state.tabPositionIndex);

        return Scaffold(
          key: cubit.scaffoldKey,
          drawer: const AppDrawer(),
          body: _TabPages(
            openDrawer: () {
              Future.microtask(() {
                cubit.openDrawer();
              });
            },
            tabIndex: tabPositionIndex,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabPositionIndex,
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: theme.iconTheme.copyWith(
              color: theme.primaryColor,
            ),
            selectedLabelStyle: theme.textTheme.labelSmall,
            unselectedLabelStyle: theme.textTheme.labelSmall,
            unselectedItemColor: theme.iconTheme.color,
            showUnselectedLabels: true,
            onTap: cubit.changeTabIndex,
            selectedItemColor: theme.primaryColor,
            items: bottomBarItems,
          ),
        );
      }),
    );
  }
}

class _TabPages extends StatelessWidget {
  final int tabIndex;
  final List<Widget> _tabs;
  final VoidCallback openDrawer;

  _TabPages({
    required this.tabIndex,
    required this.openDrawer,
  }) : _tabs = _buildTabs(openDrawer);

  static List<Widget> _buildTabs(
    VoidCallback openDrawer,
  ) {
    return <Widget>[
      Navigator(
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
              builder: (BuildContext context) => const DashboardV1Screen())),
      /**
          Navigator(
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
          builder: (BuildContext context) => const ArticlesScreen())),
       */
      Navigator(
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
              builder: (BuildContext context) => const SessionsScreen())),
      Navigator(
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
              builder: (BuildContext context) => const AccountScreen())),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: tabIndex,
      children: _tabs,
    );
  }
}
