import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/presentation/screens/home_screen/cubit/main_home_screen_cubit.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/domain/repositories/zodiac_articles_repository.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/screens/home/home_cubit.dart';
import 'package:zodiac/presentation/screens/home/home_state.dart';
import 'package:zodiac/presentation/screens/home/tabs_types.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/custom_bottom_navigation_bar.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class HomeScreen extends StatelessWidget {
  final TabsTypes? initTab;

  const HomeScreen({Key? key, this.initTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VoidCallback openDrawer =
        context.read<MainHomeScreenCubit>().openDrawer;
    return BlocProvider(
        create: (_) => HomeCubit(
              zodiacGetIt.get<ZodiacCachingManager>(),
              zodiacGetIt.get<ZodiacMainCubit>(),
              zodiacGetIt.get<WebSocketManager>(),
              zodiacGetIt.get<ZodiacArticlesRepository>(),
            ),
        child: Builder(
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
                            icon: e == TabsTypes.articles
                                ? _ArticleIcon(
                                    child: SvgPicture.asset(
                                    e.iconPath,
                                    color: index == cubit.state.tabPositionIndex
                                        ? theme.primaryColor
                                        : theme.shadowColor,
                                  ))
                                : SvgPicture.asset(
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

class _ArticleIcon extends StatelessWidget {
  final Widget child;

  const _ArticleIcon({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Builder(builder: (context) {
          final int? count = context
              .select((HomeCubit cubit) => cubit.state.articlesUnreadCount);
          if (count != null && count != 0) {
            return Positioned(
              top: -2.0,
              right: -7.0,
              child: Container(
                width: 16.0,
                height: 16.0,
                decoration: const BoxDecoration(
                  color: AppColors.promotion,
                  shape: BoxShape.circle,
                ),
                child: Builder(builder: (_) {
                  return FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        count.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: theme.backgroundColor),
                      ),
                    ),
                  );
                }),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }
}
