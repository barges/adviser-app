import 'package:shared_advisor_interface/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/extensions.dart';

class OldNoteDateWidget extends StatelessWidget {
  final String? updatedAt;
  const OldNoteDateWidget({Key? key, this.updatedAt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalScreenPadding,
        vertical: 12.0,
      ),
      child: Text(
        updatedAt?.parseDateTimePattern10 ?? '',
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).shadowColor,
            ),
      ),
    );
  }
}
