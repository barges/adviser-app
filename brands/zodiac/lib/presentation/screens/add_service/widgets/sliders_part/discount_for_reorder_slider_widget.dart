import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/slider_widget.dart';

class DiscountForReorderWidget extends StatelessWidget {
  const DiscountForReorderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AddServiceCubit addServiceCubit = context.read<AddServiceCubit>();
    final bool discountEnabled =
        context.select((AddServiceCubit cubit) => cubit.state.discountEnabled);

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
                onChanged: addServiceCubit.onDiscountEnabledChanged,
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
                final double price = context
                    .select((AddServiceCubit cubit) => cubit.state.price);
                final double discount = context
                    .select((AddServiceCubit cubit) => cubit.state.discount);
                return SliderWidget(
                  value: discount,
                  min: minDiscount,
                  max: maxDiscount,
                  stepSize: 1,
                  onChanged: addServiceCubit.onDiscountChanged,
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
