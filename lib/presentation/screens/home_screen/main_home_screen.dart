/*import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../data/cache/fortunica_caching_manager.dart';
import '../../../fortunica_main_cubit.dart';
import '../../../global.dart';
import '../../../infrastructure/di/inject_config.dart';
import '../../../services/check_permission_service.dart';
import '../../../services/fresh_chat_service.dart';
import '../../../utils/utils.dart';
import '../brand_screen/fortunica_brand_screen.dart';
import '../drawer/app_drawer.dart';
import 'cubit/main_home_screen_cubit.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    globalGetIt
        .get<FreshChatService>()
        .initFreshChat(Utils.isDarkMode(context));
    await Future.delayed(const Duration(milliseconds: 700));
    await AppTrackingTransparency.requestTrackingAuthorization();
    // ignore: use_build_context_synchronously
    await globalGetIt.get<CheckPermissionService>().handlePermission(
        context, PermissionType.notification,
        needShowSettings: false);

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocProvider(
        create: (_) => MainHomeScreenCubit(
          fortunicaMainCubit: fortunicaGetIt.get<FortunicaMainCubit>(),
          cachingManager: fortunicaGetIt.get<FortunicaCachingManager>(),
        ),
        child: Builder(builder: (context) {
          final MainHomeScreenCubit homeScreenCubit =
              context.read<MainHomeScreenCubit>();
          final bool isAuth =
              context.select((MainHomeScreenCubit cubit) => cubit.state.isAuth);
          return Scaffold(
            key: homeScreenCubit.scaffoldKey,
            drawer: isAuth
                ? AppDrawer(
                    scaffoldKey: homeScreenCubit.scaffoldKey,
                  )
                : null,
            // TODO check if it works
            //drawerEnableOpenDragGesture: false,
            body: const FortunicaBrandScreen(),
            //const FortunicaBrandScreen(),
          );
        }),
      );

      /*AutoTabsRouter(
        routes: homeScreenCubit.routes,
        lazyLoad: false,
        duration: Duration.zero,
        builder: (context, child, animation) {
          final tabsRouter = AutoTabsRouter.of(context);

          return Scaffold(
            key: homeScreenCubit.scaffoldKey,
            // TODO DELETE
            /*drawer: AppDrawer(
                  scaffoldKey: homeScreenCubit.scaffoldKey,
                ),*/
            body: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );

          // TODO DELETE
          /*BlocListener<MainCubit, MainState>(
              listenWhen: (prev, current) =>
                  prev.currentBrand != current.currentBrand,
              listener: (_, state) {
                tabsRouter.setActiveIndex(
                  homeScreenCubit.brands.indexWhere(
                      (e) => state.currentBrand?.brandAlias == e.brandAlias),
                );
              },
              child: Scaffold(
                key: homeScreenCubit.scaffoldKey,
                // TODO DELETE
                /*drawer: AppDrawer(
                  scaffoldKey: homeScreenCubit.scaffoldKey,
                ),*/
                body: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              ));*/
        },
      );*/
    });
  }
}
*/