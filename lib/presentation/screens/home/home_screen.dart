import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_controller.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/history/history_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/inbox/inbox_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_screen.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: _TabPages(
          tabIndex: controller.tabPositionIndex.value,
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.tabPositionIndex.value,
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: Get.theme.iconTheme.copyWith(
              color: Get.theme.primaryColor,
            ),
            selectedLabelStyle: Get.textTheme.labelSmall,
            unselectedLabelStyle: Get.textTheme.labelSmall,
            unselectedItemColor: Get.iconColor,
            showUnselectedLabels: true,
            onTap: (index) {
              controller.tabPositionIndex.value = index;
            },
            selectedItemColor: Get.theme.primaryColor,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.inbox,
                ),
                activeIcon: SvgPicture.asset(
                  AppIcons.inbox,
                  color: Get.theme.primaryColor,
                ),
                label: 'Inbox',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.sessions,
                ),
                activeIcon: SvgPicture.asset(
                  AppIcons.sessions,
                  color: Get.theme.primaryColor,
                ),
                label: 'Sessions',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.history,
                ),
                activeIcon: SvgPicture.asset(
                  AppIcons.history,
                  color: Get.theme.primaryColor,
                ),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.account,
                ),
                activeIcon: SvgPicture.asset(
                  AppIcons.account,
                  color: Get.theme.primaryColor,
                ),
                label: 'Account',
              ),
            ]),
      );
    });
  }
}

class _TabPages extends StatelessWidget {
  final int tabIndex;
  final List<Widget> _tabs;

  _TabPages({
    required this.tabIndex,
  }) : _tabs = _buildTabs();

  static List<Widget> _buildTabs() {
    return <Widget>[
      Navigator(
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
              builder: (BuildContext context) => const InboxScreen())),
      Navigator(
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
              builder: (BuildContext context) => const SessionsScreen())),
      Navigator(
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
              builder: (BuildContext context) => const HistoryScreen())),
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
