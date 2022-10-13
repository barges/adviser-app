import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_month.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/balance_and_transactions_cubit.dart';
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
              physics: const ClampingScrollPhysics(),
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

                    final bool hasPrevious =
                        currentMonthIndex < months.length - 1;

                    final bool hasNext = currentMonthIndex > 0;

                    if (months.isNotEmpty) {
                      final ReportsMonth month = months[currentMonthIndex];
                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(
                            AppConstants.horizontalScreenPadding,
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 8.0,
                                ),
                                height: 48.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.buttonRadius),
                                  color: Get.theme.canvasColor,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Opacity(
                                      opacity: hasPrevious ? 1.0 : 0.4,
                                      child: AppIconButton(
                                        icon: Assets.vectors.arrowLeft.path,
                                        onTap: () {
                                          if (hasPrevious) {
                                            balanceAndTransactionsCubit
                                                .updateCurrentMonthIndex(
                                                    currentMonthIndex + 1);
                                          }
                                        },
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 18.0,
                                              child: Text(
                                                month.monthName ?? '',
                                                style: Get.textTheme.labelMedium
                                                    ?.copyWith(
                                                  color: Get.theme.primaryColor,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Assets.vectors.arrowDown.svg(
                                              color: Get.theme.primaryColor,
                                              height: 18.0,
                                              width: 18.0,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 14.0,
                                          child: Text(
                                            month.monthsDate
                                                    ?.split('-')
                                                    .firstOrNull ??
                                                '',
                                            style: Get.textTheme.bodySmall
                                                ?.copyWith(
                                              fontSize: 12.0,
                                              color: Get.theme.shadowColor,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Opacity(
                                      opacity: hasNext ? 1.0 : 0.4,
                                      child: AppIconButton(
                                        icon: Assets.vectors.arrowRight.path,
                                        onTap: () {
                                          if (hasNext) {
                                            balanceAndTransactionsCubit
                                                .updateCurrentMonthIndex(
                                                    currentMonthIndex - 1);
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
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
