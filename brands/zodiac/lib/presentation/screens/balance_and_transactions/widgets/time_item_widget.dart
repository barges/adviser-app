import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/zodiac_extensions.dart';

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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            color: Theme.of(context).canvasColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
          child: Text(
            dateTime.listTime(context),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 14.0,
                  color: Theme.of(context).shadowColor,
                ),
          ),
        ),
      ),
    );
  }
}
