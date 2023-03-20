import 'package:shared_advisor_interface/configuration.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/screens/home/home_cubit.dart';
import 'package:fortunica/presentation/screens/home/home_state.dart';
import 'package:fortunica/presentation/screens/home/tabs_types.dart';

class HomeScreen extends StatelessWidget {
  final TabsTypes? initTab;
  const HomeScreen({Key? key, this.initTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) {
          return HomeCubit(
              fortunicaGetIt.get<FortunicaCachingManager>(),
          initTab,
            );
        },
        child: Builder(
          builder: (context) {
            final ThemeData theme = Theme.of(context);
            final HomeCubit cubit = context.read<HomeCubit>();

            return AutoTabsRouter(
              routes: cubit.routes,
              lazyLoad: false,
              builder: (context, child, animation){
                final tabsRouter = AutoTabsRouter.of(context);

                return BlocListener<HomeCubit, HomeState>(
                  listenWhen: (prev, current) =>
                  prev.tabPositionIndex != current.tabPositionIndex,
                  listener: (_, state) {
                    tabsRouter.setActiveIndex(
                      state.tabPositionIndex,
                    );
                  },
                  child: Scaffold(
                    body: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                      currentIndex: tabsRouter.activeIndex,
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
                  ),
                );
              },
            );
          },
        ));
  }
}
