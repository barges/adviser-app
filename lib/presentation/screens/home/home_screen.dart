import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_controller.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/articles/articles_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/chats/chats_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/dashboard_screen.dart';
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
                  AppIcons.dashboard,
                ),
                activeIcon: SvgPicture.asset(
                  AppIcons.dashboard,
                  color: Get.theme.primaryColor,
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.articles,
                ),
                activeIcon: SvgPicture.asset(
                  AppIcons.articles,
                  color: Get.theme.primaryColor,
                ),
                label: 'Articles',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.chats,
                ),
                activeIcon: SvgPicture.asset(
                  AppIcons.chats,
                  color: Get.theme.primaryColor,
                ),
                label: 'Chats',
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
              builder: (BuildContext context) => const DashboardScreen())),
      Navigator(
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
              builder: (BuildContext context) => const ArticlesScreen())),
      Navigator(
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
              builder: (BuildContext context) => const ChatsScreen())),
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
