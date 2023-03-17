import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/wrappers/auth_wrapper/zodiac_auth_wrapper_cubit.dart';
import 'package:zodiac/presentation/wrappers/auth_wrapper/zodiac_auth_wrapper_state.dart';

class ZodiacAuthWrapper extends StatelessWidget {
  const ZodiacAuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ZodiacAuthWrapperCubit(),
        child: BlocListener<ZodiacAuthWrapperCubit, ZodiacAuthWrapperState>(
            listenWhen: (prev, current) => prev.isAuth != current.isAuth,
            listener: (_, state) {
              logger.d(state.isAuth);
              if (state.isAuth) {
                zodiacGetIt
                    .get<AppRouter>()
                    .replaceAll(context, [const ZodiacMain()]);
              }
            },
            child: Builder(builder: (context) {
              final bool isProcessingData = context.select(
                      (ZodiacAuthWrapperCubit cubit) => cubit.state.isProcessingData);

              final bool isAuth = context
                  .select((ZodiacAuthWrapperCubit cubit) => cubit.state.isAuth);

              return !isAuth && !isProcessingData
                  ? const AutoRouter()
                  : const Scaffold(
                  body: SizedBox.shrink()
              );
            })));
  }
}
