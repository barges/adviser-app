import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:fortunica/domain/repositories/fortunica_user_repository.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:fortunica/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:fortunica/presentation/common_widgets/no_connection_widget.dart';
import 'package:fortunica/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_cubit.dart';
import 'package:fortunica/presentation/screens/home/tabs/dashboard_v1/widgets/month_statistic_widget.dart';
import 'package:fortunica/presentation/screens/home/tabs/dashboard_v1/widgets/personal_information_widget.dart';

class DashboardV1Screen extends StatelessWidget {
  const DashboardV1Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => DashboardV1Cubit(
              fortunicaGetIt.get<FortunicaCachingManager>(),
              fortunicaGetIt.get<ConnectivityService>(),
              fortunicaGetIt.get<FortunicaUserRepository>(),
              fortunicaGetIt.get<FortunicaMainCubit>(),
            ),
        child: Builder(builder: (context) {
          DashboardV1Cubit dashboardCubit = context.read<DashboardV1Cubit>();
          final bool isOnline = context.select(
              (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
          final AppError appError = context
              .select((FortunicaMainCubit cubit) => cubit.state.appError);
          return Scaffold(
              appBar: HomeAppBar(
                withBrands: true,
                title: SFortunica.of(context).dashboardFortunica,
                iconPath: Assets.vectors.items.path,
              ),
              body: Column(
                children: [
                  AppErrorWidget(
                    errorMessage: appError.getMessage(context),
                    close: dashboardCubit.closeErrorWidget,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: dashboardCubit.refreshInfo,
                      child: CustomScrollView(slivers: [
                        isOnline
                            ? SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      AppConstants.horizontalScreenPadding),
                                  child: Column(
                                    children: const [
                                      PersonalInformationWidget(),
                                      SizedBox(
                                        height: AppConstants
                                            .horizontalScreenPadding,
                                      ),
                                      MonthStatisticWidget()
                                    ],
                                  ),
                                ),
                              )
                            : SliverFillRemaining(
                                hasScrollBody: false,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    NoConnectionWidget(),
                                  ],
                                ),
                              ),
                      ]),
                    ),
                  ),
                ],
              ));
        }));
  }
}
