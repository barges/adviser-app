import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/zodiac_extensions.dart';

const timeItemHeight = 22.0;

class TimeItemWidget extends StatelessWidget {
  final DateTime dateTime;
  const TimeItemWidget({
    super.key,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: timeItemHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            color: Theme.of(context).canvasColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
          child: Text(
            dateTime.listTime(context),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).shadowColor,
                ),
          ),
        ),
      ),
    );
  }
}
