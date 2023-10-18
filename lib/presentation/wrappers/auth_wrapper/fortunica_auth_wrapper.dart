/*import 'package:fortunica_for_readers/infrastructure/routing/app_router.dart';
import 'package:fortunica_for_readers/infrastructure/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../global.dart';
import '../../screens/home/tabs_types.dart';
import 'fortunica_auth_wrapper_cubit.dart';
import 'fortunica_auth_wrapper_state.dart';

class FortunicaAuthWrapper extends StatelessWidget {
  final TabsTypes? initTab;
  const FortunicaAuthWrapper({Key? key, this.initTab}) : super(key: key);

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
                    print('!!!!!');
                    //context.replaceAll([FortunicaHome(initTab: initTab)]);
                  }
                },
                child: Builder(builder: (context) {
                  final bool isProcessingData = context.select(
                      (FortunicaAuthWrapperCubit cubit) =>
                          cubit.state.isProcessingData);

                  final bool isAuth = context.select(
                      (FortunicaAuthWrapperCubit cubit) => cubit.state.isAuth);

                  return const AutoRouter(); /*!isAuth && !isProcessingData
                      ? const AutoRouter()
                      : const Scaffold(body: SizedBox.shrink());*/
                })));
  }
}*/
