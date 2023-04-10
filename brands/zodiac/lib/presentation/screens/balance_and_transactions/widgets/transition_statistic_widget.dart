import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/presentation/screens/balance_and_transactions/widgets/chart_widget.dart';

class TransitionStatisticWidget extends StatelessWidget {
  const TransitionStatisticWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalScreenPadding),
      child: ChartWidget(),
    );
  }
}
