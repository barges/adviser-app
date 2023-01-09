import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CachingManager cacheManager = getIt.get<CachingManager>();
    final ConnectivityService connectivityService =
        getIt.get<ConnectivityService>();
    final UserRepository userRepository = getIt.get<UserRepository>();
    return BlocProvider(
      create: (_) => HomeCubit(
        cacheManager,
        connectivityService,
        userRepository,
        getIt.get<PushNotificationManager>(),
      ),
      child: HomeContentWidget(
        cacheManager: cacheManager,
        connectivityService: connectivityService,
        userRepository: userRepository,
        chatsRepository: getIt.get<ChatsRepository>(),
      ),
    );
  }
}

class HomeContentWidget extends StatelessWidget {
  final CachingManager cacheManager;
  final ConnectivityService connectivityService;
  final ChatsRepository chatsRepository;
  final UserRepository userRepository;

  const HomeContentWidget({
    super.key,
    required this.cacheManager,
    required this.connectivityService,
    required this.chatsRepository,
    required this.userRepository,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final HomeCubit cubit = context.read<HomeCubit>();
    final int tabPositionIndex =
        context.select((HomeCubit cubit) => cubit.state.tabPositionIndex);

    return Scaffold(
      key: cubit.scaffoldKey,
      drawer: const AppDrawer(),
      body: _TabPages(
        tabIndex: tabPositionIndex,
        tabs: HomeCubit.tabsList
            .map((e) => e.getNavigator(
                context: context,
                cacheManager: cacheManager,
                connectivityService: connectivityService,
                chatsRepository: chatsRepository,
                userRepository: userRepository))
            .toList(),
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
