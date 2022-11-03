import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_statistics.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/dashboard_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/pages/resources_page/widgets/chart_widget.dart';

class PerformanceDashboardWidget extends StatelessWidget {
  const PerformanceDashboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 12.0, horizontal: AppConstants.horizontalScreenPadding),
      decoration: BoxDecoration(
          color: Get.theme.canvasColor,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //TODO - Replace with ChooseOptionWidget later
          _DisabledChooseOptionWidget(
            options: [
              S.of(context).today,
              S.of(context).thisWeek,
              S.of(context).thisMonth
            ],
            currentIndex:
                2, //context.select((DashboardCubit cubit) => cubit.state.dashboardDateFilterIndex),
            onChangeOptionIndex:
                context.read<DashboardCubit>().updateDashboardDateFilterIndex,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
                vertical: AppConstants.horizontalScreenPadding),
            child: Divider(height: 1.0),
          ),
          Row(
            children: [
              Builder(builder: (context) {
                final double monthAmount = context
                    .select((DashboardCubit cubit) => cubit.state.monthAmount);
                return Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('\$ ${monthAmount.parseValueToCurrencyFormat}',
                        style: Get.textTheme.labelLarge),
                    /**
                        Row(
                          children: [
                            _PerformancePropertyInfo(
                                title: S.of(context).newCustomers, info: 6),
                            const SizedBox(width: 8.0),
                            _PerformancePropertyInfo(
                                title: S.of(context).sales, info: 98),
                          ],
                        )
                      */
                  ],
                ));
              }),
              AppIconButton(icon: Assets.vectors.arrowRight.path)
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
                vertical: AppConstants.horizontalScreenPadding),
            child: Divider(height: 1.0),
          ),
          const ChartWidget()
        ],
      ),
    );
  }
}

class _PerformancePropertyInfo extends StatelessWidget {
  final String title;
  final int info;

  const _PerformancePropertyInfo(
      {Key? key, required this.title, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minWidth: 20.0, minHeight: 20.0),
          decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              borderRadius: BorderRadius.circular(8.0)),
          child: Text(
            info.toString(),
            style: Get.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500, color: Get.theme.backgroundColor),
          ),
        ),
        const SizedBox(width: 4.0),
        Text(
          title,
          style: Get.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        )
      ]),
    );
  }
}

//TODO - Delete this temporary widget later
class _DisabledChooseOptionWidget extends StatelessWidget {
  final List<String> options;
  final int currentIndex;
  final ValueChanged<int>? onChangeOptionIndex;

  const _DisabledChooseOptionWidget({
    Key? key,
    required this.options,
    required this.currentIndex,
    required this.onChangeOptionIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options
            .mapIndexed(
              (element, index) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (onChangeOptionIndex != null) {
                      onChangeOptionIndex!(index);
                    }
                  },
                  child: Opacity(
                    opacity: index == currentIndex ? 1.0 : 0.4,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      decoration: BoxDecoration(
                          color: currentIndex == index
                              ? Get.theme.primaryColor
                              : Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(AppConstants.buttonRadius)),
                      child: Text(
                        element,
                        style: Get.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: currentIndex == index
                              ? Get.theme.backgroundColor
                              : Get.theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
