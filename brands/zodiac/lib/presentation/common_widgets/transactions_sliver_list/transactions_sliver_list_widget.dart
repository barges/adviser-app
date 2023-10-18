import 'package:flutter/material.dart';
import 'package:zodiac/data/models/payment/transaction_ui_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/empty_list_widget.dart';
import 'package:zodiac/presentation/common_widgets/transactions_sliver_list/time_item_widget.dart';
import 'package:zodiac/presentation/common_widgets/transactions_sliver_list/transaction_tile_widget.dart';

const paddingTopTimeItem = 16.0;
const paddingBottomTimeItem = 8.0;

class TransactionsSliverListWidget extends StatelessWidget {
  final List<TransactionUiModel> transactionsList;
  const TransactionsSliverListWidget({Key? key, required this.transactionsList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transactionsList.isNotEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return transactionsList[index].when(
                data: (data) => TransactionsTileWidget(
                      items: data,
                    ),
                separator: (dateCreate) => Padding(
                      padding: EdgeInsets.only(
                          top: index == 0 ? 0.0 : paddingTopTimeItem,
                          bottom: paddingBottomTimeItem),
                      child: TimeItemWidget(dateTime: dateCreate!),
                    ));
          },
          childCount: transactionsList.length,
        ),
      );
    } else {
      return SliverFillRemaining(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyListWidget(
              title: SZodiac.of(context).noTransactionsYetZodiac,
              label: SZodiac.of(context)
                  .yourTransactionsHistoryWillAppearHereZodiac,
            ),
          ],
        ),
      );
    }
  }
}
