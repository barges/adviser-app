import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zodiac/data/models/payment/payment_information.dart';
import 'package:zodiac/data/models/payment/transaction_ui_model.dart';
import 'package:zodiac/presentation/common_widgets/transactions_sliver_list/time_item_widget.dart';
import 'package:zodiac/presentation/common_widgets/transactions_sliver_list/transaction_tile_widget.dart';
import 'package:zodiac/presentation/common_widgets/transactions_sliver_list/transactions_sliver_list_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/widgets/user_info_part_widget.dart';

class SkeletonPlaceholderWidget extends StatelessWidget {
  const SkeletonPlaceholderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScreenPadding, vertical: 16.0),
          sliver: SliverToBoxAdapter(
            child: Shimmer.fromColors(
                baseColor: theme.hintColor,
                highlightColor: theme.canvasColor,
                child: DashboardUserInfoPartWidget()),
          ),
        ),
        SkeletonTransactionsListWidget(),
      ],
    );
  }
}

class SkeletonTransactionsListWidget extends StatelessWidget {
  const SkeletonTransactionsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(AppConstants.horizontalScreenPadding,
          0.0, AppConstants.horizontalScreenPadding, 16.0),
      sliver: SliverToBoxAdapter(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => _transactionsList[index].when(
            data: (data) => Shimmer.fromColors(
              baseColor: theme.hintColor,
              highlightColor: theme.canvasColor,
              child: TransactionsTileWidget(
                items: data,
              ),
            ),
            separator: (dateCreate) => Padding(
              padding: EdgeInsets.only(
                  top: index == 0 ? 0.0 : paddingTopTimeItem,
                  bottom: paddingBottomTimeItem),
              child: Shimmer.fromColors(
                  baseColor: theme.hintColor,
                  highlightColor: theme.canvasColor,
                  child: TimeItemWidget(dateTime: dateCreate!)),
            ),
          ),
          itemCount: _transactionsList.length,
        ),
      ),
    );
  }
}

List<TransactionUiModel> _transactionsList = [
  TransactionUiModel.separator(DateTime.now()),
  TransactionUiModel.data(
    List.generate(2, (index) => const PaymentInformation()),
  ),
  TransactionUiModel.separator(DateTime.now()),
  TransactionUiModel.data(
    List.generate(1, (index) => const PaymentInformation()),
  ),
  TransactionUiModel.separator(DateTime.now()),
  TransactionUiModel.data(
    List.generate(1, (index) => const PaymentInformation()),
  ),
  TransactionUiModel.separator(DateTime.now()),
  TransactionUiModel.data(
    List.generate(3, (index) => const PaymentInformation()),
  ),
];
