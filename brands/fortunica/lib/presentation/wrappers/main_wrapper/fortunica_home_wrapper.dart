import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/wrappers/main_wrapper/fortunica_home_wrapper_cubit.dart';
import 'package:fortunica/presentation/wrappers/main_wrapper/fortunica_home_wrapper_state.dart';

class FortunicaHomeWrapper extends StatelessWidget {
  const FortunicaHomeWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => FortunicaHomeWrapperCubit(),
        child: BlocListener<FortunicaHomeWrapperCubit, FortunicaHomeWrapperState>(
            listenWhen: (prev, current) => prev.isAuth != current.isAuth,
            listener: (_, state) {
              if (!state.isAuth) {
                fortunicaGetIt
                    .get<AppRouter>()
                    .replaceAll(context, [const FortunicaAuth()]);
              }
            },
            child: Builder(builder: (context) {
              final bool isProcessingData = context.select(
                      (FortunicaHomeWrapperCubit cubit) => cubit.state.isProcessingData);

              final bool isAuth = context
                  .select((FortunicaHomeWrapperCubit cubit) => cubit.state.isAuth);

              return isAuth && !isProcessingData
                  ? const AutoRouter()
                  : const Scaffold(
                body: SizedBox.shrink()
              );
            })));
  }
}
