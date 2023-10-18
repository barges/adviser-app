import 'package:flutter/material.dart';

import '../../../../../../app_constants.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../common_widgets/empty_list_widget.dart';

class EmptyHistoryListWidget extends StatelessWidget {
  const EmptyHistoryListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmptyListWidget(
                    title: SFortunica.of(context).noSessionsYetFortunica,
                    label: SFortunica.of(context)
                        .whenYouHelpYourFirstClientYouWillSeeYourSessionHistoryHereFortunica,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
