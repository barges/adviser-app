import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/screens/home/home_cubit.dart';
import 'package:fortunica/presentation/screens/home/home_state.dart';
import 'package:fortunica/presentation/screens/home/tabs_types.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/custom_bottom_navigation_bar.dart';
import 'package:shared_advisor_interface/presentation/screens/home_screen/cubit/main_home_screen_cubit.dart';

class HomeScreen extends StatelessWidget {
  final TabsTypes? initTab;
  const HomeScreen({Key? key, this.initTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VoidCallback openDrawer =
        context.read<MainHomeScreenCubit>().openDrawer;
    return BlocProvider(create: (_) {
      return HomeCubit(
        fortunicaGetIt.get<FortunicaCachingManager>(),
        initTab,
      );
    }, child: Builder(
      builder: (context) {
        final ThemeData theme = Theme.of(context);
        final HomeCubit cubit = context.read<HomeCubit>();

        return WillPopScope(
          onWillPop: () async {
            openDrawer();
            return false;
          },
          child: AutoTabsRouter(
            routes: cubit.routes,
            lazyLoad: false,
            builder: (context, child, animation) {
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
                  bottomNavigationBar: CustomBottomNavigationBar(
                    backgroundColor: theme.canvasColor,
                    onTap: cubit.changeTabIndex,
                    items: HomeCubit.tabsList.mapIndexed((index, e) {
                      return CustomBottomNavigationItem(
                        activeColor: theme.primaryColor,
                        inactiveColor: theme.shadowColor,
                        icon: SvgPicture.asset(
                          e.iconPath,
                          color: index == cubit.state.tabPositionIndex
                              ? theme.primaryColor
                              : theme.shadowColor,
                        ),
                        label: e.tabName(context),
                        labelStyle: theme.textTheme.labelSmall,
                        isSelected: index == cubit.state.tabPositionIndex,
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        );
      },
    ));
  }
}