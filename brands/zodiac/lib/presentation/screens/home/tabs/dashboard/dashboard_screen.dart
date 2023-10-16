import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/common_widgets/no_connection_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/dashboard_cubit.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/widgets/dashboard_body_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => zodiacGetIt.get<DashboardCubit>(),
      child: Scaffold(
        appBar: HomeAppBar(
          title: SZodiac.of(context).dashboardZodiac,
          withBrands: true,
          iconPath: Assets.vectors.items.path,
        ),
        body: Builder(builder: (context) {
          final bool internetConnectionIsAvailable = context.select(
              (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);

          if (internetConnectionIsAvailable) {
            return Stack(
              children: [
                const DashboardBodyWidget(),
                Positioned(
                    top: 0.0,
                    right: 0.0,
                    left: 0.0,
                    child: Builder(builder: (context) {
                      final AppError appError = context.select(
                          (ZodiacMainCubit cubit) => cubit.state.appError);
                      return AppErrorWidget(
                        errorMessage: appError.getMessage(context),
                        close:
                            context.read<ZodiacMainCubit>().clearErrorMessage,
                      );
                    }))
              ],
            );
          } else {
            return const CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NoConnectionWidget(),
                    ],
                  ),
                )
              ],
            );
          }
        }),
      ),
    );
  }
}
