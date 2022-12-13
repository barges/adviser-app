import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocProvider(
      create: (_) => HomeCubit(
        cacheManager: getIt.get<CachingManager>(),
        context: context,
      ),
      child: Builder(builder: (context) {
        final HomeCubit cubit = context.read<HomeCubit>();
        final int tabPositionIndex =
            context.select((HomeCubit cubit) => cubit.state.tabPositionIndex);

        return Scaffold(
          key: cubit.scaffoldKey,
          drawer: const AppDrawer(),
          body: _TabPages(
            tabIndex: tabPositionIndex,
            tabs:
                HomeCubit.tabsList.map((e) => e.getNavigator(context)).toList(),
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
            items: HomeCubit.tabsList
                .map(
                  (e) => BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      e.iconPath,
                      color: theme.shadowColor,
                    ),
                    activeIcon: SvgPicture.asset(
                      e.iconPath,
                      color: theme.primaryColor,
                    ),
                    label: e.tabName(context),
                  ),
                )
                .toList(),
          ),
        );
      }),
    );
  }
}

class _TabPages extends StatelessWidget {
  final int tabIndex;
  final List<Widget> tabs;

  const _TabPages({
    required this.tabIndex,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: tabIndex,
      children: tabs,
    );
  }
}
