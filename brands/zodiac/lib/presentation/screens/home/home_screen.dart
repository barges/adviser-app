import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/network/websocket_manager/websocket_manager.dart';
import 'package:zodiac/domain/repositories/zodiac_articles_repository.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/screens/home/home_cubit.dart';
import 'package:zodiac/presentation/screens/home/home_state.dart';
import 'package:zodiac/presentation/screens/home/tabs_types.dart';

class HomeScreen extends StatelessWidget {
  final TabsTypes? initTab;

  const HomeScreen({Key? key, this.initTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => HomeCubit(
              zodiacGetIt.get<ZodiacCachingManager>(),
              zodiacGetIt.get<WebSocketManager>(),
              zodiacGetIt.get<ZodiacArticlesRepository>(),
            ),
        child: Builder(
          builder: (context) {
            final ThemeData theme = Theme.of(context);
            final HomeCubit cubit = context.read<HomeCubit>();

            return AutoTabsRouter(
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
                      items: HomeCubit.tabsList.map((e) {
                        return BottomNavigationBarItem(
                          icon: e == TabsTypes.articles
                              ? _ArticleIcon(
                              child: SvgPicture.asset(
                                e.iconPath,
                                color: theme.shadowColor,
                              ))
                              : SvgPicture.asset(
                            e.iconPath,
                            color: theme.shadowColor,
                          ),
                          activeIcon: e == TabsTypes.articles
                              ? _ArticleIcon(
                            child: SvgPicture.asset(
                              e.iconPath,
                              color: theme.primaryColor,
                            ),
                          )
                              : SvgPicture.asset(
                            e.iconPath,
                            color: theme.primaryColor,
                          ),
                          label: e.tabName(context),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}

class _ArticleIcon extends StatelessWidget {
  final Widget child;

  const _ArticleIcon({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final int? count =
          context.select((HomeCubit cubit) => cubit.state.articleCount);
      return Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          if (count != null)
            Positioned(
              top: -2.0,
              right: -7.0,
              child: Container(
                width: 16.0,
                height: 16.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFEA4E9D),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: const Color(0xFFFFFFFF)),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
