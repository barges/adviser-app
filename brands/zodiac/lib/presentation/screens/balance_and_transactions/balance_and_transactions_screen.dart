import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:zodiac/data/models/payment/transaction_ui_model.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:zodiac/presentation/common_widgets/empty_list_widget.dart';
import 'package:zodiac/presentation/common_widgets/no_connection_widget.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/balance_and_transactions_cubit.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/widgets/label_widget.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/widgets/time_item_widget.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/widgets/transaction_statistic_widget.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/widgets/transaction_tile_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

const paddingTopTimeItem = 16.0;
const paddingBottomTimeItem = 8.0;
const paddingottomStatisticWidget = 24.0 - paddingTopTimeItem;
const paddingTopLabelWidget = 8.0;

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
        zodiacGetIt.get<ConnectivityService>(),
      ),
      child: Builder(builder: (context) {
        final BalanceAndTransactionsCubit balanceAndTransactionsCubit =
            context.read<BalanceAndTransactionsCubit>();
        final List<TransactionUiModel>? transactionsList = context.select(
            (BalanceAndTransactionsCubit cubit) =>
                cubit.state.transactionsList);
        final bool internetConnectionIsAvailable = context.select(
            (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);

        return Scaffold(
          floatingActionButton: const _FloatingActionButton(),
          body: SafeArea(
            top: false,
            child: RefreshIndicator(
              onRefresh: () =>
                  balanceAndTransactionsCubit.getPaymentsList(refresh: true),
              edgeOffset: (AppConstants.appBarHeight * 2) +
                  MediaQuery.of(context).padding.top,
              notificationPredicate: (_) => internetConnectionIsAvailable,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  CustomScrollView(
                    controller: balanceAndTransactionsCubit.scrollController,
                    physics: const ClampingScrollPhysics()
                        .applyTo(const AlwaysScrollableScrollPhysics()),
                    slivers: [
                      ScrollableAppBar(
                        title: SZodiac.of(context).balanceTransactionsZodiac,
                        needShowError: transactionsList != null,
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
                      SliverPersistentHeader(
                        delegate: _DelegateLabelWidget(),
                        pinned: true,
                      ),
                      Builder(builder: (context) {
                        if (transactionsList == null &&
                            !internetConnectionIsAvailable) {
                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                NoConnectionWidget(),
                              ],
                            ),
                          );
                        } else if (transactionsList == null) {
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
                                  if (index == 0) {
                                    return const Padding(
                                      padding: EdgeInsets.only(
                                          bottom: paddingottomStatisticWidget),
                                      child: TransactionStatisticWidget(),
                                    );
                                  }
                                  return transactionsList[index - 1].when(
                                      data: (data) => TransactionsTileWidget(
                                            items: data,
                                          ),
                                      separator: (dateCreate) => Padding(
                                            padding: const EdgeInsets.only(
                                                top: paddingTopTimeItem,
                                                bottom: paddingBottomTimeItem),
                                            child: TimeItemWidget(
                                                dateTime: dateCreate!),
                                          ));
                                },
                                childCount: transactionsList.length + 1,
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
                onPressed: () => balanceAndTransactionsCubit.scrollController
                    .animateTo(0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear),
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

class _DelegateLabelWidget extends SliverPersistentHeaderDelegate {
  final double _extent = paddingTopLabelWidget + labelWidgetHeight;

  @override
  double get maxExtent => _extent;

  @override
  double get minExtent => _extent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: maxExtent,
      child: Builder(builder: (context) {
        final DateTime? dateLabel = context.select(
            (BalanceAndTransactionsCubit cubit) => cubit.state.dateLabel);
        final bool isVisibleDateLabel = context.select(
            (BalanceAndTransactionsCubit cubit) =>
                cubit.state.isVisibleDateLabel);
        return isVisibleDateLabel && dateLabel != null
            ? LabelWidget(dateLabel: dateLabel)
            : const SizedBox.shrink();
      }),
    );
  }
}
