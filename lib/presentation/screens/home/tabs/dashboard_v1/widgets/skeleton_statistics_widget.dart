import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../app_constants.dart';

class SkeletonStatisticsWidget extends StatelessWidget {
  const SkeletonStatisticsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalScreenPadding, vertical: 16.0),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: theme.hintColor,
            highlightColor: theme.canvasColor,
            child: Container(
              height: 48.0,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(
                AppConstants.horizontalScreenPadding,
              ),
              decoration: BoxDecoration(
                color: theme.hintColor,
                borderRadius: BorderRadius.circular(
                  AppConstants.buttonRadius,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Shimmer.fromColors(
            baseColor: theme.hintColor,
            highlightColor: theme.canvasColor,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(
                AppConstants.horizontalScreenPadding,
              ),
              decoration: BoxDecoration(
                color: theme.hintColor,
                borderRadius: BorderRadius.circular(
                  AppConstants.buttonRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
