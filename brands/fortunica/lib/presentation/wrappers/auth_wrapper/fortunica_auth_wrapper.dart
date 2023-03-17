import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/presentation/wrappers/auth_wrapper/fortunica_auth_wrapper_cubit.dart';
import 'package:fortunica/presentation/wrappers/auth_wrapper/fortunica_auth_wrapper_state.dart';

class FortunicaAuthWrapper extends StatelessWidget {
  const FortunicaAuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) {
          return FortunicaAuthWrapperCubit();
        },
        child:
            BlocListener<FortunicaAuthWrapperCubit, FortunicaAuthWrapperState>(
                listenWhen: (prev, current) => prev.isAuth != current.isAuth,
                listener: (_, state) {
                  logger.d(state.isAuth);
                  if (state.isAuth) {
                    context.replaceAll([FortunicaHome()]);
                  }
                },
                child: Builder(builder: (context) {
                  final bool isProcessingData = context.select(
                      (FortunicaAuthWrapperCubit cubit) =>
                          cubit.state.isProcessingData);

                  final bool isAuth = context.select(
                      (FortunicaAuthWrapperCubit cubit) => cubit.state.isAuth);

                  return !isAuth && !isProcessingData
                      ? const AutoRouter()
                      : const Scaffold(body: SizedBox.shrink());
                })));
  }
}
