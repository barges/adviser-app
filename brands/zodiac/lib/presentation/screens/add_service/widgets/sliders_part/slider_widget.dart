import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:zodiac/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/sf_round_rect_tooltip_shape.dart';

typedef ValueFormatter = String Function(double value);

class SliderWidget extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final double stepSize;
  final ValueChanged<dynamic> onChanged;
  final ValueFormatter tooltipFormater;
  final ValueFormatter labelFormatter;

  const SliderWidget({
    Key? key,
    required this.value,
    required this.min,
    required this.max,
    required this.stepSize,
    required this.onChanged,
    required this.tooltipFormater,
    required this.labelFormatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(
          height: 50.0,
        ),
        Row(
          children: [
            AppIconButton(
              icon: Assets.vectors.minus.path,
              onTap: () => onChanged(value - stepSize),
            ),
            Expanded(
              child: SfSliderTheme(
                data: SfSliderThemeData(
                  tooltipTextStyle: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 17.0,
                    color: theme.canvasColor,
                  ),
                  thumbRadius: 12.0,
                  overlayRadius: 0.0,
                  activeTrackHeight: 4.0,
                ),
                child: SfSlider(
                  value: value,
                  min: min,
                  max: max,
                  stepSize: stepSize,
                  onChanged: onChanged,
                  inactiveColor: theme.hintColor,
                  activeColor: theme.primaryColor,
                  shouldAlwaysShowTooltip: true,
                  tooltipShape: SfRoundRectangularTooltipShape(
                    color: theme.primaryColor,
                    horizontalPadding: 16.0,
                    verticalPadding: 9.0,
                    cornerRadius: 12.0,
                    textStyle: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 17.0,
                      color: theme.canvasColor,
                    ),
                  ),
                  tooltipTextFormatterCallback: (actualValue, formattedText) =>
                      tooltipFormater(value),
                  thumbIcon: Padding(
                    padding: const EdgeInsets.all(1.5),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AppIconButton(
              icon: Assets.vectors.plus.path,
              onTap: () => onChanged(value + stepSize),
            )
          ],
        ),
        const SizedBox(
          height: 4.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              labelFormatter(min),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.shadowColor,
              ),
            ),
            Text(
              labelFormatter(max),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.shadowColor,
              ),
            ),
          ],
        )
      ],
    );
  }
}
