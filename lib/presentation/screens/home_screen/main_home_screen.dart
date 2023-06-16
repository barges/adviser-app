import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/main_state.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/home_screen/cubit/main_home_screen_cubit.dart';
import 'package:shared_advisor_interface/services/check_permission_service.dart';
import 'package:shared_advisor_interface/services/fresh_chat_service.dart';
import 'package:shared_advisor_interface/utils/utils.dart';

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
    return BlocProvider(
      create: (_) => MainHomeScreenCubit(
        globalGetIt.get<BrandManager>(),
      ),
      child: Builder(builder: (context) {
        final MainHomeScreenCubit homeScreenCubit =
            context.read<MainHomeScreenCubit>();
        return AutoTabsRouter(
          routes: homeScreenCubit.routes,
          lazyLoad: false,
          duration: Duration.zero,
          builder: (context, child, animation) {
            final tabsRouter = AutoTabsRouter.of(context);

            return BlocListener<MainCubit, MainState>(
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
                  drawer: AppDrawer(
                    scaffoldKey: homeScreenCubit.scaffoldKey,
                  ),
                  body: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                ));
          },
        );
      }),
    );
  }
}
