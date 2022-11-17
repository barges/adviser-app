import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/pages/resources_page/widgets/balance_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/pages/resources_page/widgets/performance_moma_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/pages/resources_page/widgets/performance_widget.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        BalanceWidget(),
        SizedBox(height: AppConstants.horizontalScreenPadding),
        PerformanceDashboardWidget(),
        SizedBox(height: AppConstants.horizontalScreenPadding),
        PerformanceMOMAWidget()
      ]),
    );
  }
}
