import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/zodiac_extensions.dart';

const labelWidgetHeight = 22.0;

class LabelWidget extends StatelessWidget {
  final DateTime dateLabel;

  const LabelWidget({
    super.key,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    final String monthYear =
        DateFormat(datePattern7).format(dateLabel.toLocal());
    final style = Theme.of(context).textTheme.displaySmall?.copyWith(
          fontSize: 14.0,
          color: AppColors.white,
        );
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          height: labelWidgetHeight,
          child: Blur(
            borderRadius: BorderRadius.circular(16.0),
            colorOpacity: 0.15,
            blur: 10.0,
            blurColor: Colors.black,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
              child: Text(
                monthYear,
                style: style?.copyWith(color: Colors.black.withOpacity(0)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(monthYear, style: style),
        )
      ],
    );
  }
}
