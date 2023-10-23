import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../app_constants.dart';
import '../../../../../data/cache/caching_manager.dart';
import '../../../../../data/models/app_error/app_error.dart';
import '../../../../../data/models/reports_endpoint/reports_month.dart';
import '../../../../../data/models/reports_endpoint/reports_statistics.dart';
import '../../../../../domain/repositories/fortunica_user_repository.dart';
import '../../../../../generated/assets/assets.gen.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../global.dart';
import '../../../../../main_cubit.dart';
import '../../../../../services/connectivity_service.dart';
import '../../../../common_widgets/appbar/home_app_bar.dart';
import '../../../../common_widgets/messages/app_error_widget.dart';
import '../../../../common_widgets/no_connection_widget.dart';
import '../../../../common_widgets/statistics/empty_statistics_widget.dart';
import '../../../../common_widgets/statistics/statistics_widget.dart';
import 'dashboard_v1_cubit.dart';
import 'widgets/personal_information_widget.dart';
import 'widgets/skeleton_statistics_widget.dart';

class DashboardV1Screen extends StatelessWidget {
  const DashboardV1Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MainCubit mainCubit = context.read<MainCubit>();

    return BlocProvider(
        create: (_) => DashboardV1Cubit(
              globalGetIt.get<CachingManager>(),
              globalGetIt.get<ConnectivityService>(),
              globalGetIt.get<FortunicaUserRepository>(),
              mainCubit,
            ),
        child: Builder(builder: (context) {
          DashboardV1Cubit dashboardCubit = context.read<DashboardV1Cubit>();
          final bool isOnline = context.select(
              (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
          final AppError appError =
              context.select((MainCubit cubit) => cubit.state.appError);
          final List<ReportsMonth> months =
              context.select((DashboardV1Cubit cubit) => cubit.state.months);

          return Scaffold(
              appBar: HomeAppBar(
                  withBrands: true,
                  title: SFortunica.of(context).dashboardFortunica,
                  iconPath: Assets.vectors.items.path),
              body: Column(
                children: [
                  AppErrorWidget(
                    errorMessage: appError.getMessage(context),
                    close: dashboardCubit.closeErrorWidget,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: dashboardCubit.refreshInfo,
                      child: CustomScrollView(
                        slivers: isOnline
                            ? [
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      AppConstants.horizontalScreenPadding,
                                      16.0,
                                      AppConstants.horizontalScreenPadding,
                                      0.0,
                                    ),
                                    child: months.isNotEmpty
                                        ? const PersonalInformationWidget()
                                        : Shimmer.fromColors(
                                            baseColor: theme.hintColor,
                                            highlightColor: theme.canvasColor,
                                            child:
                                                const PersonalInformationWidget()),
                                  ),
                                ),
                                Builder(builder: (context) {
                                  final ReportsStatistics? statistics =
                                      context.select((DashboardV1Cubit cubit) =>
                                          cubit.state.reportsStatistics);
                                  final int currentMonthIndex = context.select(
                                      (DashboardV1Cubit cubit) =>
                                          cubit.state.currentMonthIndex);

                                  final bool isEmptyStatistics =
                                      months.length == 1 &&
                                          statistics?.markets?.isEmpty == true;
                                  if (months.isNotEmpty) {
                                    return !isEmptyStatistics
                                        ? StatisticsWidget(
                                            months: months,
                                            currentMonthIndex:
                                                currentMonthIndex,
                                            statistics: statistics,
                                            setIndex: dashboardCubit
                                                .updateCurrentMonthIndex,
                                          )
                                        : const EmptyStatisticsWidget();
                                  } else {
                                    return const SliverToBoxAdapter(
                                      child: SkeletonStatisticsWidget(),
                                    );
                                  }
                                }),
                              ]
                            : [
                                const SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      NoConnectionWidget(),
                                    ],
                                  ),
                                )
                              ],
                      ),
                    ),
                  ),
                ],
              ));
        }));
  }
}
