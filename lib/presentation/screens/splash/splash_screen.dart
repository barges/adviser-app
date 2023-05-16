import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/splash/splash_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/splash/splash_state.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

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
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return SplashCubit(
          getIt.get<CachingManager>(),
          Utils.isDarkMode(context),
        );
      },
      child: Builder(
        builder: (context) {
          return BlocListener<SplashCubit, SplashState>(
            listener: (prev, current) {
              if (current.isLogged == true) {
                Get.offNamed(AppRoutes.home);
              } else {
                Get.offNamed(AppRoutes.login);
              }
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: Center(
                // height: size.height,
                // width: size.width,
                child: splashLogo,
              ),
            ),
          );
        },
      ),
    );
  }
}
