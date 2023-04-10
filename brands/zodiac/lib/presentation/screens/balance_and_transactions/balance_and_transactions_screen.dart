import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/payment/transaction_ui_model.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:zodiac/presentation/common_widgets/empty_list_widget.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/balance_and_transactions_cubit.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/widgets/time_item_widget.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/widgets/transition_statistic_widget.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/widgets/transitions_tile_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class BalanceAndTransactionsScreen extends StatelessWidget {
  final UserBalance userBalance;
  const BalanceAndTransactionsScreen({
    Key? key,
    required this.userBalance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BalanceAndTransactionsCubit(
        zodiacGetIt.get<ZodiacMainCubit>(),
        zodiacGetIt.get<ZodiacUserRepository>(),
      ),
      child: Builder(builder: (context) {
        final BalanceAndTransactionsCubit balanceAndTransactionsCubit =
            context.read<BalanceAndTransactionsCubit>();
        return Scaffold(
          floatingActionButton: const _FloatingActionButton(),
          body: SafeArea(
            top: false,
            child: RefreshIndicator(
              onRefresh: () =>
                  balanceAndTransactionsCubit.getPaymentsList(refresh: true),
              edgeOffset: (AppConstants.appBarHeight * 2) +
                  MediaQuery.of(context).padding.top,
              child: Stack(
                children: [
                  CustomScrollView(
                    controller: balanceAndTransactionsCubit.scrollController,
                    physics: const ClampingScrollPhysics()
                        .applyTo(const AlwaysScrollableScrollPhysics()),
                    slivers: [
                      ScrollableAppBar(
                        title: SZodiac.of(context).balanceTransactionsZodiac,
                        label: Builder(builder: (context) {
                          final UserBalance? balance = context.select(
                              (BalanceAndTransactionsCubit cubit) =>
                                  cubit.state.userBalance);
                          return Text(
                            balance == null
                                ? userBalance.toString()
                                : balance.toString(),
                            textAlign: TextAlign.right,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontSize: 20.0,
                                    color: Theme.of(context).primaryColor),
                          );
                        }),
                      ),
                      Builder(builder: (context) {
                        final List<TransactionUiModel>? transactionsList =
                            context.select(
                                (BalanceAndTransactionsCubit cubit) =>
                                    cubit.state.transactionsList);
                        if (transactionsList == null ||
                            transactionsList.isEmpty) {
                          return const SliverToBoxAdapter(
                            child: SizedBox.shrink(),
                          );
                        } else {
                          return const SliverPadding(
                            padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                            sliver: SliverToBoxAdapter(
                              child: TransitionStatisticWidget(),
                            ),
                          );
                        }
                      }),
                      Builder(builder: (context) {
                        final List<TransactionUiModel>? transactionsList =
                            context.select(
                                (BalanceAndTransactionsCubit cubit) =>
                                    cubit.state.transactionsList);
                        if (transactionsList == null) {
                          return const SliverToBoxAdapter(
                            child: SizedBox.shrink(),
                          );
                        } else if (transactionsList.isNotEmpty) {
                          return SliverPadding(
                            padding: const EdgeInsets.only(
                                left: AppConstants.horizontalScreenPadding,
                                right: AppConstants.horizontalScreenPadding,
                                bottom: 14.0),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return transactionsList[index].when(
                                      data: (data) => TransitionsTileWidget(
                                            items: data,
                                          ),
                                      separator: (dateCreate) => Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0, bottom: 8.0),
                                            child: TimeItemWidget(
                                                dateTime: dateCreate!),
                                          ));
                                },
                                childCount: transactionsList.length,
                              ),
                            ),
                          );
                        } else {
                          return SliverFillRemaining(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                EmptyListWidget(
                                  title: SZodiac.of(context)
                                      .noTransactionsYetZodiac,
                                  label: SZodiac.of(context)
                                      .yourTransactionsHistoryWillAppearHereZodiac,
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                  Builder(builder: (context) {
                    final DateTime? monthLabel = context.select(
                        (BalanceAndTransactionsCubit cubit) =>
                            cubit.state.monthLabel);
                    return monthLabel != null
                        ? Positioned(
                            top: 8,
                            child: TimeItemWidget(dateTime: monthLabel),
                          )
                        : const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final BalanceAndTransactionsCubit balanceAndTransactionsCubit =
          context.read<BalanceAndTransactionsCubit>();
      final bool isVisibleUpButton = context.select(
          (BalanceAndTransactionsCubit cubit) => cubit.state.isVisibleUpButton);
      return isVisibleUpButton
          ? Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).canvasColor,
                splashColor: Theme.of(context).canvasColor,
                elevation: 0.0,
                highlightElevation: 0.0,
                enableFeedback: false,
                shape: CircleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                child: const _UpButtonIcon(),
                onPressed: () =>
                    balanceAndTransactionsCubit.scrollController.jumpTo(0.0),
              ),
            )
          : const SizedBox.shrink();
    });
  }
}

class _UpButtonIcon extends StatelessWidget {
  const _UpButtonIcon();

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 2,
      child: SvgPicture.asset(
        width: 24.0,
        Assets.vectors.arrowDown.path,
      ),
    );
  }
}
