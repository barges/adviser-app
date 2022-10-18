import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_month.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_statistics.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/balance_and_transactions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/widgets/empty_statistics_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/widgets/statistics_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';

class BalanceAndTransactionsScreen extends StatelessWidget {
  const BalanceAndTransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BalanceAndTransactionsCubit(),
      child: Builder(builder: (context) {
        final BalanceAndTransactionsCubit balanceAndTransactionsCubit =
            context.read<BalanceAndTransactionsCubit>();
        return Scaffold(
          key: balanceAndTransactionsCubit.scaffoldKey,
          drawer: const AppDrawer(),
          body: SafeArea(
            top: false,
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
                  Builder(builder: (context) {
                    return ScrollableAppBar(
                      title: S.of(context).balanceTransactions,
                      openDrawer: balanceAndTransactionsCubit.openDrawer,
                    );
                  }),
                  if (months.isNotEmpty)
                    !isEmptyStatistics
                        ? StatisticsWidget(
                            months: months,
                            currentMonthIndex: currentMonthIndex,
                            statistics: statistics,
                          )
                        : const EmptyStatisticsWidget(),
                ],
              );
            }),
          ),
        );
      }),
    );
  }
}
