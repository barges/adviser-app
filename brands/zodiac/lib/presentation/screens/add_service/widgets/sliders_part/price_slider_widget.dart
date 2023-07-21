import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/slider_widget.dart';

class PriceSliderWidget extends StatelessWidget {
  const PriceSliderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AddServiceCubit addServiceCubit = context.read<AddServiceCubit>();

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
          Text(
            SZodiac.of(context).priceZodiac,
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 17.0),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Builder(builder: (context) {
            final double price =
                context.select((AddServiceCubit cubit) => cubit.state.price);
            return SliderWidget(
              value: price,
              min: minPrice,
              max: maxPrice,
              stepSize: 5,
              onChanged: addServiceCubit.onPriceChanged,
              tooltipFormater: (value) => '\$${value.toStringAsFixed(2)}',
              labelFormatter: (value) => '\$${value.toStringAsFixed(2)}',
            );
          }),
        ],
      ),
    );
  }
}
