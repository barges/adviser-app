import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        ZodiacDashboard(),
        ZodiacArticles(),
        ZodiacChats(),
        ZodiacAccount(),
      ],
      builder: (context, child, animation) {
        // obtain the scoped TabsRouter controller using context
        final tabsRouter = AutoTabsRouter.of(context);
        // Here we're building our Scaffold inside of AutoTabsRouter
        // to access the tabsRouter controller provided in this context
        //
        //alterntivly you could use a global key
        return Scaffold(
            appBar: AppBar(
              title: const Text('Zodiac'),
            ),
            body: FadeTransition(
              opacity: animation,
              // the passed child is techinaclly our animated selected-tab page
              child: child,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: tabsRouter.activeIndex,
              onTap: (index) {
                // here we switch between tabs
                tabsRouter.setActiveIndex(index);
              },
              unselectedItemColor: Colors.grey,
              selectedItemColor: Colors.purple,
              items: const [
                BottomNavigationBarItem(label: 'Dashboard', icon: Icon(Icons.home)),
                BottomNavigationBarItem(label: 'Articles', icon: Icon(Icons.newspaper)),
                BottomNavigationBarItem(label: 'Chats', icon: Icon(Icons.message)),
                BottomNavigationBarItem(label: 'Account', icon: Icon(Icons.person)),
              ],
            ));
      },
    );
  }
}
