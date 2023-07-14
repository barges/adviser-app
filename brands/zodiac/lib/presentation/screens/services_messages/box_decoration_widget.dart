import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';

class BoxDecorationWidget extends StatelessWidget {
  final Widget? child;
  const BoxDecorationWidget({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        color: theme.canvasColor,
      ),
      padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
      child: child,
    );
  }
}
