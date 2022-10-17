import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_month.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_statistics.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/balance_and_transactions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/widgets/list_of_markets_by_month.dart';
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/widgets/month_header_widget.dart';
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
            child: CustomScrollView(
              slivers: [
                Builder(builder: (context) {
                  return ScrollableAppBar(
                    title: S.of(context).balanceTransactions,
                    openDrawer: balanceAndTransactionsCubit.openDrawer,
                  );
                }),
                SliverToBoxAdapter(
                  child: Builder(builder: (context) {
                    final List<ReportsMonth> months = context.select(
                        (BalanceAndTransactionsCubit cubit) =>
                            cubit.state.months);

                    final int currentMonthIndex = context.select(
                        (BalanceAndTransactionsCubit cubit) =>
                            cubit.state.currentMonthIndex);

                    if (months.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(
                          AppConstants.horizontalScreenPadding,
                        ),
                        child: Column(
                          children: [
                            MonthHeaderWidget(
                              months: months,
                              currentMonthIndex: currentMonthIndex,
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Builder(builder: (context) {
                              final ReportsStatistics? statistics = context
                                  .select((BalanceAndTransactionsCubit cubit) =>
                                      cubit.state.reportsStatistics);
                              if (statistics != null) {
                                return ListOfMarketsByMonth(
                                  reportsStatistics: statistics,
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            })
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
