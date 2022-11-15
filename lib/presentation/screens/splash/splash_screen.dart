import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/splash/splash_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/splash/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit(getIt.get<CachingManager>()),
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
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Assets.images.splash.image(
                  fit: BoxFit.fill,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
