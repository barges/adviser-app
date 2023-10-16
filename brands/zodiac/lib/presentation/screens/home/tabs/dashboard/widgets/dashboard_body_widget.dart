import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/payment/transaction_ui_model.dart';
import 'package:zodiac/presentation/common_widgets/transactions_sliver_list/transactions_sliver_list_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/dashboard_cubit.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/widgets/user_info_part_widget.dart';

class DashboardBodyWidget extends StatefulWidget {
  const DashboardBodyWidget({Key? key}) : super(key: key);

  @override
  State<DashboardBodyWidget> createState() => _DashboardBodyWidgetState();
}

class _DashboardBodyWidgetState extends State<DashboardBodyWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.extentBefore > 300) {
        context.read<DashboardCubit>().getPaymentsList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final DashboardCubit dashboardCubit = context.read<DashboardCubit>();
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: dashboardCubit.refreshDashboard,
        child: CustomScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics()
              .applyTo(const AlwaysScrollableScrollPhysics()),
          slivers: [
            const SliverPadding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalScreenPadding,
                  vertical: 16.0),
              sliver: SliverToBoxAdapter(
                child: DashboardUserInfoPartWidget(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  AppConstants.horizontalScreenPadding,
                  0.0,
                  AppConstants.horizontalScreenPadding,
                  16.0),
              sliver: Builder(builder: (context) {
                final List<TransactionUiModel>? transactionsList =
                    context.select(
                        (DashboardCubit cubit) => cubit.state.transactionsList);

                if (transactionsList != null) {
                  return TransactionsSliverListWidget(
                      transactionsList: transactionsList);
                } else {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
