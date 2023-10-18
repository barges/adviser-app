import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../main_cubit.dart';
import '../drawer/app_drawer.dart';

class FortunicaBrandScreen extends StatelessWidget {
  const FortunicaBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final MainCubit mainCubit = context.read<MainCubit>();
      final bool isAuth =
          context.select((MainCubit cubit) => cubit.state.isAuth);
      return Scaffold(
          key: mainCubit.scaffoldKey,
          drawer: AppDrawer(
            scaffoldKey: mainCubit.scaffoldKey,
          ),
          // it works on device
          drawerEnableOpenDragGesture: isAuth,
          body: const AutoRouter());
    });
  }
}
