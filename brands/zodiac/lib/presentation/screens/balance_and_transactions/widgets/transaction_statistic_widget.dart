import 'package:flutter/material.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/widgets/chart_widget.dart';

const statisticWidgetHeight = 214.0;

class TransactionStatisticWidget extends StatelessWidget {
  const TransactionStatisticWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: statisticWidgetHeight,
      child: ChartWidget(),
    );
  }
}
