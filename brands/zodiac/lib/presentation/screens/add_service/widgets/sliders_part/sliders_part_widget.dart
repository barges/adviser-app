import 'package:flutter/material.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/delivery_time_slider_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/discount_for_reorder_slider_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/price_slider_widget.dart';

class SlidersPartWidget extends StatelessWidget {
  const SlidersPartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        PriceSliderWidget(),
        SizedBox(
          height: 24.0,
        ),
        DeliveryTimeSliderWidget(),
        SizedBox(
          height: 24.0,
        ),
        DiscountForReorderWidget(),
      ],
    );
  }
}
