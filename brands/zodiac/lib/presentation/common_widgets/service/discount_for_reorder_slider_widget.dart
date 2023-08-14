import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/service/slider_widget.dart';
import 'package:zodiac/zodiac_constants.dart';

class DiscountForReorderWidget extends StatelessWidget {
  final bool discountEnabled;
  final ValueChanged<bool> onDiscountEnabledChanged;
  final double price;
  final double discount;
  final ValueChanged onDiscountChanged;

  const DiscountForReorderWidget({
    Key? key,
    required this.discountEnabled,
    required this.onDiscountEnabledChanged,
    required this.price,
    required this.discount,
    required this.onDiscountChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                SZodiac.of(context).discountForReorderZodiac,
                style: theme.textTheme.headlineMedium?.copyWith(fontSize: 17.0),
              ),
              CupertinoSwitch(
                value: discountEnabled,
                activeColor: theme.primaryColor,
                onChanged: onDiscountEnabledChanged,
              ),
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          Opacity(
            opacity: discountEnabled ? 1.0 : 0.6,
            child: IgnorePointer(
              ignoring: !discountEnabled,
              child: Builder(builder: (context) {
                return SliderWidget(
                  value: discount,
                  min: ZodiacConstants.serviceMinDiscount,
                  max: ZodiacConstants.serviceMaxDiscount,
                  stepSize: 1,
                  onChanged: onDiscountChanged,
                  tooltipFormater: (value) =>
                      '${value.toStringAsFixed(0)}% \$${(price * (1 - discount / 100)).toStringAsFixed(2)}',
                  labelFormatter: (value) => '${value.toStringAsFixed(0)}%',
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
