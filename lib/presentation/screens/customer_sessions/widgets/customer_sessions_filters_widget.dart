import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_constants.dart';
import '../../../../data/models/enums/markets_type.dart';
import '../../../common_widgets/list_of_filters_widget.dart';
import '../../../common_widgets/market_filter_widget.dart';
import '../customer_sessions_cubit.dart';

class CustomerSessionsFiltersWidget extends StatelessWidget {
  final bool isOnline;
  const CustomerSessionsFiltersWidget({Key? key, required this.isOnline})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerSessionsCubit customerSessionsCubit =
        context.read<CustomerSessionsCubit>();
    final int? currentFilterIndex = context.select(
        (CustomerSessionsCubit cubit) => cubit.state.currentFilterIndex);
    final List<MarketsType> userMarkets = context
        .select((CustomerSessionsCubit cubit) => cubit.state.userMarkets);
    final int currentMarketIndex = context.select(
        (CustomerSessionsCubit cubit) => cubit.state.currentMarketIndex);
    return Opacity(
      opacity: isOnline ? 1.0 : 0.4,
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.only(right: AppConstants.horizontalScreenPadding),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ListOfFiltersWidget(
              currentFilterIndex: currentFilterIndex,
              onTapToFilter: isOnline
                  ? customerSessionsCubit.changeFilterIndex
                  : (value) {},
              filters: customerSessionsCubit.filters
                  .map((e) => e.filterName(context))
                  .toList(),
              withMarketFilter: true,
            ),
            MarketFilterWidget(
                userMarkets: userMarkets,
                currentMarketIndex: currentMarketIndex,
                changeIndex: isOnline
                    ? customerSessionsCubit.changeMarketIndex
                    : (value) {}),
          ],
        ),
      ),
    );
  }
}
