import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../infrastructure/routing/app_router.dart';
import '../../../data/cache/caching_manager.dart';
import '../../../generated/assets/assets.gen.dart';
import '../../../global.dart';
import '../../../infrastructure/routing/app_router.gr.dart';
import '../../../services/check_permission_service.dart';
import '../../../services/fresh_chat_service.dart';
import '../../../utils/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SvgPicture splashLogo;

  @override
  void initState() {
    super.initState();
    splashLogo = SvgPicture.asset(Assets.vectors.splashLogo.path);
  }

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

    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (globalGetIt.get<CachingManager>().isAuth) {
        context.replaceAll([FortunicaHome()]);
      } else {
        context.replaceAll([const FortunicaLogin()]);
      }
    });

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: splashLogo,
      ),
    ); //,
  }
}
