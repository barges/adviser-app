import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/wrappers/main_wrapper/zodiac_home_wrapper_cubit.dart';
import 'package:zodiac/presentation/wrappers/main_wrapper/zodiac_home_wrapper_state.dart';

class ZodiacHomeWrapper extends StatelessWidget {
  const ZodiacHomeWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ZodiacHomeWrapperCubit(),
        child: BlocListener<ZodiacHomeWrapperCubit, ZodiacHomeWrapperState>(
            listenWhen: (prev, current) => prev.isAuth != current.isAuth,
            listener: (_, state) {
              if (!state.isAuth) {
                zodiacGetIt
                    .get<AppRouter>()
                    .replaceAll(context, [const ZodiacAuth()]);
              }
            },
            child: Builder(builder: (context) {
              final bool isProcessingData = context.select(
                      (ZodiacHomeWrapperCubit cubit) => cubit.state.isProcessingData);

              final bool isAuth = context
                  .select((ZodiacHomeWrapperCubit cubit) => cubit.state.isAuth);

              return isAuth && !isProcessingData
                  ? const AutoRouter()
                  : const Scaffold(
                  body: SizedBox.shrink()
              );
            })));
  }
}
