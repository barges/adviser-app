import 'package:flutter/material.dart';

import '../../../../app_constants.dart';
import '../../../../data/models/reports_endpoint/reports_month.dart';
import '../../../../generated/assets/assets.gen.dart';
import '../../../common_widgets/buttons/app_icon_button.dart';
import '../../../common_widgets/picker_modal_pop_up.dart';

class MonthHeaderWidget extends StatelessWidget {
  final List<ReportsMonth> months;
  final int currentMonthIndex;
  final ValueSetter<int> setIndex;

  const MonthHeaderWidget(
      {Key? key,
      required this.months,
      required this.currentMonthIndex,
      required this.setIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasPrevious = currentMonthIndex < months.length - 1;

    final bool hasNext = currentMonthIndex > 0;

    final ReportsMonth month = months[currentMonthIndex];
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      height: 48.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        color: Theme.of(context).canvasColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Opacity(
            opacity: hasPrevious ? 1.0 : 0.4,
            child: AppIconButton(
              icon: Assets.vectors.arrowLeft.path,
              onTap: () {
                if (hasPrevious) {
                  setIndex(currentMonthIndex + 1);
                }
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              if (months.length > 1) {
                showPickerModalPopUp(
                  context: context,
                  setIndex: setIndex,
                  currentIndex: currentMonthIndex,
                  elements: months
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.nameFromDate),
                                Text(e.monthDate?.split('-').firstOrNull ?? ''),
                              ],
                            ),
                          ))
                      .toList(),
                );
              }
            },
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 18.0,
                      child: Text(
                        month.nameFromDate,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ),
                    if (months.length > 1)
                      Assets.vectors.arrowDown.svg(
                        color: Theme.of(context).primaryColor,
                        height: 18.0,
                        width: 18.0,
                      )
                  ],
                ),
                SizedBox(
                  height: 14.0,
                  child: Text(
                    month.monthDate?.split('-').firstOrNull ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12.0,
                          color: Theme.of(context).shadowColor,
                        ),
                  ),
                )
              ],
            ),
          ),
          Opacity(
            opacity: hasNext ? 1.0 : 0.4,
            child: AppIconButton(
              icon: Assets.vectors.arrowRight.path,
              onTap: () {
                if (hasNext) {
                  setIndex(currentMonthIndex - 1);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
