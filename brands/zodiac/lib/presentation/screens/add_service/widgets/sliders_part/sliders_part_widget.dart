import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/common_widgets/service/discount_for_reorder_slider_widget.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/delivery_time_slider_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/price_slider_widget.dart';

class SlidersPartWidget extends StatelessWidget {
  const SlidersPartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PriceSliderWidget(),
        const SizedBox(
          height: 24.0,
        ),
        const DeliveryTimeSliderWidget(),
        const SizedBox(
          height: 24.0,
        ),
        Builder(builder: (context) {
          final AddServiceCubit addServiceCubit =
              context.read<AddServiceCubit>();

          final bool discountEnabled = context
              .select((AddServiceCubit cubit) => cubit.state.discountEnabled);
          final double price =
              context.select((AddServiceCubit cubit) => cubit.state.price);
          final double discount =
              context.select((AddServiceCubit cubit) => cubit.state.discount);

          return DiscountForReorderWidget(
            discountEnabled: discountEnabled,
            onDiscountEnabledChanged: addServiceCubit.onDiscountEnabledChanged,
            price: price,
            discount: discount,
            onDiscountChanged: addServiceCubit.onDiscountChanged,
          );
        }),
      ],
    );
  }
}
