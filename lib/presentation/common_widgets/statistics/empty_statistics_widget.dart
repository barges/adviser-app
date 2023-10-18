import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../../generated/l10n.dart';
import '../empty_list_widget.dart';

class EmptyStatisticsWidget extends StatelessWidget {
  const EmptyStatisticsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalScreenPadding,
                  ),
                  child: EmptyListWidget(
                    title: SFortunica.of(context)
                        .youHaveNotCompletedAnySessionsYetFortunica,
                  ),
                ),
              ],
            ),
          ),
          //const SeeMoreWidget(),
        ],
      ),
    );
  }
}
