import 'package:fortunica/presentation/common_widgets/statistics/empty_statistics_widget.dart';
import 'package:fortunica/presentation/common_widgets/statistics/statistics_widget.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/data/models/reports_endpoint/reports_month.dart';
import 'package:fortunica/data/models/reports_endpoint/reports_statistics.dart';
import 'package:fortunica/domain/repositories/fortunica_user_repository.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:fortunica/presentation/common_widgets/no_connection_widget.dart';
import 'package:fortunica/presentation/screens/balance_and_transactions/balance_and_transactions_cubit.dart';

class BalanceAndTransactionsScreen extends StatelessWidget {
  const BalanceAndTransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BalanceAndTransactionsCubit(
        fortunicaGetIt.get<FortunicaCachingManager>(),
        fortunicaGetIt.get<FortunicaUserRepository>(),
        fortunicaGetIt.get<FortunicaMainCubit>(),
      ),
      child: Builder(builder: (context) {
        final BalanceAndTransactionsCubit balanceAndTransactionsCubit =
            context.read<BalanceAndTransactionsCubit>();
        return Scaffold(
          key: balanceAndTransactionsCubit.scaffoldKey,
          body: SafeArea(
            top: false,
            child: BlocListener<MainCubit, MainState>(
              listenWhen: (prev, current) =>
                  prev.internetConnectionIsAvailable !=
                  current.internetConnectionIsAvailable,
              listener: (_, state) {
                if (state.internetConnectionIsAvailable) {
                  balanceAndTransactionsCubit.getReports();
                }
              },
              child: Builder(builder: (context) {
                final List<ReportsMonth> months = context.select(
                    (BalanceAndTransactionsCubit cubit) => cubit.state.months);

                final ReportsStatistics? statistics = context.select(
                    (BalanceAndTransactionsCubit cubit) =>
                        cubit.state.reportsStatistics);

                final int currentMonthIndex = context.select(
                    (BalanceAndTransactionsCubit cubit) =>
                        cubit.state.currentMonthIndex);

                final bool isEmptyStatistics =
                    months.length == 1 && statistics?.markets?.isEmpty == true;

                return CustomScrollView(
                  physics: isEmptyStatistics
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  slivers: [
                    ScrollableAppBar(
                      title:
                          SFortunica.of(context).balanceTransactionsFortunica,
                    ),
                    Builder(builder: (context) {
                      final bool isOnline = context.select((MainCubit cubit) =>
                          cubit.state.internetConnectionIsAvailable);

                      if (isOnline) {
                        if (months.isNotEmpty) {
                          return !isEmptyStatistics
                              ? StatisticsWidget(
                                  months: months,
                                  currentMonthIndex: currentMonthIndex,
                                  statistics: statistics,
                                  setIndex: balanceAndTransactionsCubit
                                      .updateCurrentMonthIndex,
                                )
                              : const EmptyStatisticsWidget();
                        } else {
                          return SliverToBoxAdapter(
                              child: RefreshIndicator(
                            onRefresh: balanceAndTransactionsCubit.getReports,
                            child: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                )
                              ],
                            ),
                          ));
                        }
                      } else {
                        return SliverFillRemaining(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              NoConnectionWidget(),
                            ],
                          ),
                        );
                      }
                    }),
                  ],
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}
