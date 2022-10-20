import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/articles/articles_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/dashboard_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(Get.find<CacheManager>()),
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
              selectedIconTheme: Get.theme.iconTheme.copyWith(
                color: Get.theme.primaryColor,
              ),
              selectedLabelStyle: Get.textTheme.labelSmall,
              unselectedLabelStyle: Get.textTheme.labelSmall,
              unselectedItemColor: Get.iconColor,
              showUnselectedLabels: true,
              onTap: cubit.changeIndex,
              selectedItemColor: Get.theme.primaryColor,
              items: [
                BottomNavigationBarItem(
                  icon: Assets.vectors.dashboard.svg(),
                  activeIcon: Assets.vectors.dashboard.svg(
                    color: Get.theme.primaryColor,
                  ),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Assets.vectors.articles.svg(),
                  activeIcon: Assets.vectors.articles.svg(
                    color: Get.theme.primaryColor,
                  ),
                  label: 'Articles',
                ),
                BottomNavigationBarItem(
                  icon: Assets.vectors.chats.svg(),
                  activeIcon: Assets.vectors.chats.svg(
                    color: Get.theme.primaryColor,
                  ),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Assets.vectors.account.svg(),
                  activeIcon: Assets.vectors.account.svg(
                    color: Get.theme.primaryColor,
                  ),
                  label: 'Account',
                ),
              ]),
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
              builder: (BuildContext context) => const DashboardScreen())),
      Navigator(
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
              builder: (BuildContext context) => const ArticlesScreen())),
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
